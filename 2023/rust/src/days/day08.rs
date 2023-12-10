use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{alphanumeric1, multispace0, multispace1},
    combinator::{map, value, verify},
    multi::{fold_many0, many0},
    sequence::{delimited, separated_pair, terminated},
    IResult,
};
use std::collections::HashMap;

use crate::ParseError;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let (instructions, nodes) = parse(data)?;

    Ok(nodes
        .iter("AAA", |node| node.id == "ZZZ", &instructions)
        .count()
        .to_string())
}

pub fn part2(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let (instructions, nodes) = parse(data)?;

    Ok(nodes
        .ghost_iter("A", |node| node.id.ends_with("Z"), &instructions)
        .enumerate()
        .inspect(|nodes| {
            dbg!(&nodes);
        })
        .count()
        .to_string())
}

#[derive(Clone, Copy, Debug)]
enum Instruction {
    Left,
    Right,
}

type NodeId<'a> = &'a str;

struct Nodes<'a> {
    node_lookup: HashMap<NodeId<'a>, Node<'a>>,
}

impl<'a> Nodes<'a> {
    fn new() -> Self {
        Self {
            node_lookup: HashMap::new(),
        }
    }

    fn push(&mut self, node: Node<'a>) {
        self.node_lookup.insert(node.id, node);
    }

    fn get(&'a self, id: NodeId) -> &Node<'a> {
        self.node_lookup.get(id).unwrap()
    }

    fn iter(
        &'a self,
        start_node_id: NodeId<'a>,
        finished: fn(&Node) -> bool,
        instructions: &'a Vec<Instruction>,
    ) -> impl Iterator<Item = &'a Node> + 'a {
        NodesIterator::new(start_node_id, finished, &instructions, &self)
    }

    fn ghost_iter(
        &'a self,
        start_suffix: &'a str,
        finished: fn(&Node) -> bool,
        instructions: &'a Vec<Instruction>,
    ) -> impl Iterator<Item = Vec<&'a Node>> + 'a {
        let start_nodes = self
            .node_lookup
            .keys()
            .filter(|node_id| node_id.ends_with(start_suffix))
            .collect::<Vec<_>>();

        GhostNodesIter::new(start_nodes, finished, instructions, &self)
    }
}

struct NodesIterator<'a> {
    current_node: &'a Node<'a>,
    finished: fn(&Node) -> bool,
    instructions: Box<dyn Iterator<Item = Instruction> + 'a>,
    nodes: &'a Nodes<'a>,
}

impl<'a> NodesIterator<'a> {
    fn new(
        start_node_id: NodeId<'a>,
        finished: fn(&Node) -> bool,
        instructions: &'a Vec<Instruction>,
        nodes: &'a Nodes<'a>,
    ) -> Self {
        Self {
            current_node: nodes.get(start_node_id),
            finished,
            instructions: Box::new(instructions.iter().copied().cycle()),
            nodes,
        }
    }
}

impl<'a> Iterator for NodesIterator<'a> {
    type Item = &'a Node<'a>;
    fn next(&mut self) -> Option<Self::Item> {
        if (self.finished)(self.current_node) {
            return None;
        }

        let instruction = self.instructions.next().unwrap();
        let next_node_id = self.current_node.next_node_id(instruction);

        let next_node = self.nodes.get(next_node_id);
        self.current_node = next_node;

        Some(next_node)
    }
}

struct GhostNodesIter<'a> {
    nodes_iterators: Option<Vec<NodesIterator<'a>>>,
    finished: fn(&Node) -> bool,
}

impl<'a> GhostNodesIter<'a> {
    fn new(
        start_nodes: Vec<&'a NodeId>,
        finished: fn(&Node) -> bool,
        instructions: &'a Vec<Instruction>,
        nodes: &'a Nodes,
    ) -> Self {
        GhostNodesIter {
            nodes_iterators: start_nodes
                .iter()
                .map(|start_node_id| {
                    Some(NodesIterator::new(
                        start_node_id,
                        |_node| false,
                        instructions,
                        nodes,
                    ))
                })
                .collect(),
            finished,
        }
    }
}

impl<'a> Iterator for GhostNodesIter<'a> {
    type Item = Vec<&'a Node<'a>>;

    fn next(&mut self) -> Option<Self::Item> {
        if self.nodes_iterators.is_none() {
            return None;
        }

        let ghost_nodes: Vec<_> = self
            .nodes_iterators
            .as_mut()
            .unwrap()
            .iter_mut()
            .map(|node_iter| node_iter.next().unwrap())
            .collect();

        if ghost_nodes.iter().all(|node| (self.finished)(node)) {
            self.nodes_iterators = None
        }
        Some(ghost_nodes)
    }
}

#[derive(Debug)]
struct Node<'a> {
    id: NodeId<'a>,
    left: NodeId<'a>,
    right: NodeId<'a>,
}

impl<'a> Node<'a> {
    fn new(id: NodeId<'a>, left: NodeId<'a>, right: NodeId<'a>) -> Self {
        Self { id, left, right }
    }

    fn next_node_id(&self, instruction: Instruction) -> &NodeId {
        match instruction {
            Instruction::Left => &self.left,
            Instruction::Right => &self.right,
        }
    }
}

fn parse(s: &str) -> Result<(Vec<Instruction>, Nodes), ParseError> {
    let (_rest, (instructions, nodes)) =
        instructions_nodes(s).map_err(|e| ParseError(e.to_string()))?;

    Ok((instructions, nodes))
}

fn instructions_nodes(s: &str) -> IResult<&str, (Vec<Instruction>, Nodes)> {
    separated_pair(instructions, multispace1, nodes)(s)
}

fn instructions(s: &str) -> IResult<&str, Vec<Instruction>> {
    many0(instruction)(s)
}

fn instruction(s: &str) -> IResult<&str, Instruction> {
    alt((
        value(Instruction::Left, tag("L")),
        value(Instruction::Right, tag("R")),
    ))(s)
}

fn nodes(s: &str) -> IResult<&str, Nodes> {
    fold_many0(
        terminated(node, multispace0),
        || Nodes::new(),
        |mut acc: Nodes, node| {
            acc.push(node);
            acc
        },
    )(s)
}

// RHQ = (QNL, HDC)
fn node(s: &str) -> IResult<&str, Node> {
    map(
        separated_pair(
            node_id,
            tag(" = "),
            delimited(
                tag("("),
                separated_pair(node_id, tag(", "), node_id),
                tag(")"),
            ),
        ),
        |(node_id, (left_id, right_id))| Node::new(node_id, left_id, right_id),
    )(s)
}

fn node_id(s: &str) -> IResult<&str, NodeId> {
    verify(alphanumeric1, |chars: &str| chars.len() == 3)(s)
}
