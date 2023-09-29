# frozen_string_literal: true

class String
  # ANSI escape codes for colors
  # https://en.wikipedia.org/wiki/ANSI_escape_code#Colors (see FG colors)
  BLACK = 30
  RED = 31
  GREEN = 32
  YELLOW = 33
  BLUE = 34
  MAGENTA = 35
  CYAN = 36
  WHITE = 37
  NONE = 0

  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def black
    colorize(BLACK)
  end

  def red
    colorize(RED)
  end

  def green
    colorize(GREEN)
  end

  def yellow
    colorize(YELLOW)
  end

  def blue
    colorize(BLUE)
  end

  def magenta
    colorize(MAGENTA)
  end

  def cyan
    colorize(CYAN)
  end

  def white
    colorize(WHITE)
  end

  def reset
    colorize(NONE)
  end
end
