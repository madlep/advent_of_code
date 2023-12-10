use nom::{
    branch::alt,
    bytes::complete::tag,
    character::complete::{alpha1, multispace0, multispace1},
    combinator::{map, value, verify},
    multi::{fold_many0, many0},
    sequence::{delimited, separated_pair, terminated},
    IResult,
};
use std::{collections::HashMap, iter::Cycle};

use crate::ParseError;

pub fn part1(data: &str) -> Result<String, Box<dyn std::error::Error>> {
    let (instructions, nodes) = parse(data)?;

    Ok(nodes
        .iter("AAA", "ZZZ", instructions.into_iter())
        .count()
        .to_string())
}

pub fn part2(_data: &str) -> Result<String, Box<dyn std::error::Error>> {
    todo!()
}

#[derive(Clone)]
enum Instruction {
    Left,
    Right,
}

struct Nodes<'a> {
    node_lookup: HashMap<NodeId<'a>, Node<'a>>,
}

type NodeId<'a> = &'a str;

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
        finish_node_id: NodeId<'a>,
        instructions: impl Iterator<Item = Instruction> + Clone + 'a,
    ) -> impl Iterator<Item = &'a Node> + 'a {
        NodesIterator::new(start_node_id, finish_node_id, instructions, &self)
    }
}

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

struct NodesIterator<'a, I> {
    current_node: &'a Node<'a>,
    finish_node_id: NodeId<'a>,
    instructions: Cycle<I>,
    nodes: &'a Nodes<'a>,
}

impl<'a, I> NodesIterator<'a, I>
where
    I: Iterator<Item = Instruction> + Clone,
{
    fn new(
        start_node_id: NodeId<'a>,
        finish_node_id: NodeId<'a>,
        instructions: I,
        nodes: &'a Nodes,
    ) -> Self {
        Self {
            current_node: nodes.get(start_node_id),
            finish_node_id,
            instructions: instructions.cycle(),
            nodes,
        }
    }
}

impl<'a, I> Iterator for NodesIterator<'a, I>
where
    I: Iterator<Item = Instruction> + Clone,
{
    type Item = &'a Node<'a>;
    fn next(&mut self) -> Option<Self::Item> {
        if self.current_node.id == self.finish_node_id {
            return None;
        }

        let instruction = self.instructions.next().unwrap();
        let next_node_id = self.current_node.next_node_id(instruction);

        let next_node = self.nodes.get(next_node_id);
        self.current_node = next_node;

        Some(next_node)
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
    verify(alpha1, |chars: &str| chars.len() == 3)(s)
}
