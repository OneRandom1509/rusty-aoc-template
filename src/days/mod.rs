pub trait Challenge {
    fn part1(&self);
    fn part2(&self);
    fn run(&self, part: i32) {
        if part == 1 {
            self.part1();
        } else if part == 2 {
            self.part2();
        } else {
            println!("Invalid part number");
        }
    }
}
