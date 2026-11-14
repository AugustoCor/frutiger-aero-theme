"""Aqua garden: grows glossy bubbles over a grassy meadow."""
from dataclasses import dataclass, field
import random

MEADOW_GREEN = "#5fd068"


@dataclass
class Bubble:
    x: float
    y: float
    radius: float = 12.0
    sheen: float = field(default_factory=lambda: random.uniform(0.6, 1.0))

    def drift(self, wind: float) -> None:
        self.x += wind * 0.5
        self.y -= self.radius / 10


class Garden:
    def __init__(self, width: int, height: int) -> None:
        self.width, self.height = width, height
        self.bubbles: list[Bubble] = []

    def spawn(self, count: int = 8) -> None:
        for _ in range(count):
            self.bubbles.append(Bubble(random.uniform(0, self.width), self.height))

    def tick(self, wind: float = 1.5) -> int:
        for bubble in self.bubbles:
            bubble.drift(wind)
        self.bubbles = [b for b in self.bubbles if b.y > 0]
        return len(self.bubbles)


if __name__ == "__main__":
    garden = Garden(800, 600)
    garden.spawn(12)
    print(f"{garden.tick()} bubbles floating over {MEADOW_GREEN}")
