defmodule Aoc2020.Day12 do
  def read(inputpath) do
    inputpath
    |> File.read!()
    |> String.trim()
    |> String.split("\r\n")
    |> Enum.map(&String.graphemes/1)
    |> Enum.map(fn x ->
      [dir | distance] = x

      %{
        :dir => dir,
        :distance => distance |> Enum.join() |> String.to_integer()
      }
    end)
    |> Enum.to_list()
  end

  def get_cords(direction, value, east, north) do
    case direction do
      "N" ->
        %{
          :east => east,
          :north => north + value
        }

      "S" ->
        %{
          :east => east,
          :north => north - value
        }

      "E" ->
        %{
          :east => east + value,
          :north => north
        }

      "W" ->
        %{
          :east => east - value,
          :north => north
        }
    end
  end

  def rotate(direction, axis, angle) do
    case direction do
      "N" ->
        case axis do
          "R" ->
            case angle do
              90 ->
                "E"

              180 ->
                "S"

              270 ->
                "W"
            end

          "L" ->
            case angle do
              90 ->
                "W"

              180 ->
                "S"

              270 ->
                "E"
            end
        end

      "S" ->
        case axis do
          "R" ->
            case angle do
              90 ->
                "W"

              180 ->
                "N"

              270 ->
                "E"
            end

          "L" ->
            case angle do
              90 ->
                "E"

              180 ->
                "N"

              270 ->
                "W"
            end
        end

      "E" ->
        case axis do
          "R" ->
            case angle do
              90 ->
                "S"

              180 ->
                "W"

              270 ->
                "N"
            end

          "L" ->
            case angle do
              90 ->
                "N"

              180 ->
                "W"

              270 ->
                "S"
            end
        end

      "W" ->
        case axis do
          "R" ->
            case angle do
              90 ->
                "N"

              180 ->
                "E"

              270 ->
                "S"
            end

          "L" ->
            case angle do
              90 ->
                "S"

              180 ->
                "E"

              270 ->
                "N"
            end
        end
    end
  end

  def traverse(paths) do
    traverse(
      %{
        :east => 0,
        :north => 0,
        :facing => "E"
      },
      paths
    )
  end

  def traverse(course, paths) do
    case Enum.count(paths) do
      0 ->
        IO.inspect(course, label: "course")
        course

      _ ->
        [currentPath | restPaths] = paths
        IO.inspect(course, label: "course")
        IO.inspect(currentPath, label: "currentPath")

        case currentPath.dir do
          "L" ->
            dir = rotate(course.facing, "L", currentPath.distance)

            course = %{
              :east => course.east,
              :north => course.north,
              :facing => dir
            }

            traverse(course, restPaths)

          "R" ->
            dir = rotate(course.facing, "R", currentPath.distance)

            course = %{
              :east => course.east,
              :north => course.north,
              :facing => dir
            }

            traverse(course, restPaths)

          "F" ->
            cords = get_cords(course.facing, currentPath.distance, course.east, course.north)

            course = %{
              :east => cords.east,
              :north => cords.north,
              :facing => course.facing
            }

            traverse(course, restPaths)

          _ ->
            cords = get_cords(currentPath.dir, currentPath.distance, course.east, course.north)

            course = %{
              :east => cords.east,
              :north => cords.north,
              :facing => course.facing
            }

            traverse(course, restPaths)
        end
    end
  end

  # Aoc2020.Day12.test
  def test do
    result =
      "./lib/day12/test.txt"
      |> read()
      |> traverse()

    p1 = Kernel.abs(result.north)
    p2 = Kernel.abs(result.east)
    d = p1 + p2
    IO.puts("Manhattan distance: #{d}")
  end

  # Aoc2020.Day12.task1
  def task1 do
    result =
      "./lib/day12/input.txt"
      |> read()
      |> traverse()

    p1 = Kernel.abs(result.north)
    p2 = Kernel.abs(result.east)
    d = p1 + p2
    IO.puts("Manhattan distance: #{d}")
  end

  def traverse_2(paths) do
    traverse_2(
      %{
        :east => 0,
        :north => 0,
        :wp_east => 10,
        :wp_north => 1
      },
      paths
    )
  end

  def traverse_2(course, paths) do
    case Enum.count(paths) do
      0 ->
        IO.inspect(course, label: "course")
        course

      _ ->
        [currentPath | restPaths] = paths
        IO.inspect(course, label: "course")
        IO.inspect(currentPath, label: "currentPath")

        case currentPath.dir do
          "L" ->
            case 360 - currentPath.distance do
              90 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => course.wp_north,
                  :wp_north => -course.wp_east
                }

                traverse_2(course, restPaths)

              180 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => -course.wp_east,
                  :wp_north => -course.wp_north
                }

                traverse_2(course, restPaths)

              270 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => -course.wp_north,
                  :wp_north => course.wp_east
                }

                traverse_2(course, restPaths)
            end

          "R" ->
            case currentPath.distance do
              90 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => course.wp_north,
                  :wp_north => -course.wp_east
                }

                traverse_2(course, restPaths)

              180 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => -course.wp_east,
                  :wp_north => -course.wp_north
                }

                traverse_2(course, restPaths)

              270 ->
                course = %{
                  :east => course.east,
                  :north => course.north,
                  :wp_east => -course.wp_north,
                  :wp_north => course.wp_east
                }

                traverse_2(course, restPaths)
            end

          "F" ->
            east = course.east + currentPath.distance * course.wp_east
            north = course.north + currentPath.distance * course.wp_north

            course = %{
              :wp_east => course.wp_east,
              :wp_north => course.wp_north,
              :east => east,
              :north => north
            }

            traverse_2(course, restPaths)

          _ ->
            cords =
              get_cords(currentPath.dir, currentPath.distance, course.wp_east, course.wp_north)

            course = %{
              :east => course.east,
              :north => course.north,
              :wp_east => cords.east,
              :wp_north => cords.north
            }

            traverse_2(course, restPaths)
        end
    end
  end

  # Aoc2020.Day12.test2
  def test2 do
    result =
      "./lib/day12/test.txt"
      |> read()
      |> traverse_2()

    p1 = Kernel.abs(result.north)
    p2 = Kernel.abs(result.east)
    d = p1 + p2
    IO.puts("Manhattan distance: #{d}")
  end

  # Aoc2020.Day12.task2
  def task2 do
    result =
      "./lib/day12/input.txt"
      |> read()
      |> traverse_2()

    p1 = Kernel.abs(result.north)
    p2 = Kernel.abs(result.east)
    d = p1 + p2
    IO.puts("Manhattan distance: #{d}")
  end
end
