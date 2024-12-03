use days::*;
mod days;
use std::env;

fn main() {
    let input: Vec<String> = env::args().collect();
    if input.len() < 3 {
        println!("Too few arguments\nUsage: cargo run <day> <part>");
    } else if input.len() > 3 {
        println!("Too many arguments!\nUsage: cargo run <day> <part>");
    } else {
        let day: i32 = input.get(1).unwrap().parse::<i32>().unwrap();
        let part: i32 = input.get(2).unwrap().parse::<i32>().unwrap();

        match day {
            _ => println!("Haven't solved that day yet xd"),
        }
    }
}
