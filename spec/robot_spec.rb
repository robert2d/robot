require "spec_helper"
require_relative "../lib/robot"

describe Robot do

  let(:position) do
    {
      x: 1,
      y: 2
    }
  end

  # ensure fresh singleton for each spec
  subject(:robot) { Singleton.__init__(Robot).instance }

  describe "@directions" do
    it "provides access to directions" do
      expect(Robot).to respond_to(:directions)
      expect(Robot.directions).to be_a(Hash)
      # our directions are rotated like a clock face
      # preserving order is paramount in ensuring it is never changed
      expect([:north, :east, :south, :west]).to eq(Robot.directions.keys)
    end
  end

  describe "relationship to table" do
    it "should create relationship to table" do
      expect(robot).to respond_to(:table)
      expect(robot.table).to be_an_instance_of(Table)
    end
  end

  describe "#move" do
    context "with valid placement on table" do
      it "returns valid placement" do
        expect(robot).to receive(:new_position).and_return(position)
        expect(robot.table).to receive(:place).and_call_original
        expect(CommandCentre.instance).not_to receive(:say)
        robot.move
      end
    end

    context "invalid placement on table" do
      it "alerts user of failed move" do
        expect(robot).to receive(:new_position).and_return(position)
        expect(robot.table).to receive(:place)
        expect(robot).to receive(:puts)
        expect(CommandCentre.instance).to receive(:say)
        robot.move
      end
    end
  end

  describe "#new_position" do
    it "fetches coordinates for move" do
      expect(robot.table).to receive(:position).and_return(position)
      expect(robot).to receive(:move_coordinates).and_return(position)
      expect(robot.new_position).to eq(x: 2, y: 4)
    end
  end

  describe "#move_coordinates" do
    it "returns coords from current face" do
      robot.direction = :north
      expect(Robot).to receive(:directions).and_call_original
      expect(robot.move_coordinates).to eq(x: 0, y: 1)
    end
  end

  describe "#right" do
    it "returns correct face clockwise" do
      robot.direction = :north
      expect(robot).to receive(:direction=).with(:east)
      expect(robot.right).to eq(:east)
    end
  end

  describe "#left" do
    it "returns correct face anti-clockwise" do
      robot.direction = :west
      expect(robot).to receive(:direction=).with(:south)
      expect(robot.left).to eq(:south)
    end
  end

  describe "#report" do
    it "outputs text and calls say" do
      expect(robot).to receive(:direction).exactly(2).times.and_return(:north)
      expect(robot).to receive(:puts).exactly(2).times
      expect(CommandCentre.instance).to receive(:say)
      expect(robot).to receive(:display_string)
      robot.report
    end
  end

  # purposefully not tested fully outside of scope
  # would move this into a module and test seperatley anyway
  describe "#display_string" do
    it "returns a grid with position" do
      robot.place("1,2,north")
      expect(robot.display_string).to be
    end
  end

  describe "#place" do
    context "with invalid args" do
      it "does nothing with nil args" do
        expect(robot.table).not_to receive(:place)
        robot.place(nil)
      end

      it "does nothing with blank string" do
        expect(robot.table).not_to receive(:place)
        robot.place("        ")
      end

      it "does nothing with malformed args" do
        expect(robot.table).not_to receive(:place)
        robot.place("1,2north")
        robot.place("north")
      end
    end

    context "with valid args" do
      context "and valid placement" do
        it "sets direction" do
          expect(robot.table).to receive(:place).with(
            "1", "2"
          ).and_call_original
          expect(robot).to receive(:direction=).with(:north)
          robot.place("1,2,north")
        end
      end

      context "and invalid placement" do
        it "does not set direction when place fails" do
          expect(robot.table).to receive(:place).with("1", "2")
          expect(robot).not_to receive(:direction=)
          robot.place("1,2,north")
        end
      end
    end
  end

  describe "#direction=" do
    context "fails validation" do
      it "does not save to singleton" do
        robot.direction = :up
        expect(robot.direction).not_to be
      end
    end
    context "passes validation" do
      it "does save to singleton" do
        robot.direction = :west
        expect(robot.direction).to eq(:west)
      end
    end
  end

end
