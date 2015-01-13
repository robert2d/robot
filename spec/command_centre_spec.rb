require "spec_helper"
require_relative "../lib/command_centre"

describe CommandCentre do

  subject { CommandCentre.instance }

  describe "@commands" do
    it "provides access to commands" do
      expect(CommandCentre).to respond_to(:commands)
      expect(CommandCentre.commands).to be_an(Array)
    end
  end

  describe "#parse_and_execute" do
    context "invalid command" do
      let(:command) { double("Command") }
      it "returns without executing" do
        expect(CommandCentre::Command).to receive(:new).and_return(command)
        expect(command).to receive(:validate)
        expect(command).not_to receive(:execute)
        subject.parse_and_execute("test")
      end
    end

    context "valid command" do
      it "validates and executes command" do
        expect_any_instance_of(CommandCentre::Command).to receive(:execute)
        subject.parse_and_execute(CommandCentre.commands.sample)
      end
    end
  end

  describe CommandCentre::Command do
    describe "#new" do
      subject { CommandCentre::Command }

      it "constucts valid Command" do
        expect(subject.new("test")).to respond_to(:command, :args, :robot)
      end
    end

    describe "#validate" do
      context "is invalid" do
        subject { CommandCentre::Command.new("test") }

        it "returns false" do
          expect(subject.validate).not_to be
        end
      end

      context "is valid" do
        subject { CommandCentre::Command.new(CommandCentre.commands.sample) }

        it "returns false" do
          expect(subject.validate).to be
        end
      end
    end

    describe "#execute" do
      context "with PLACE command" do
        subject { CommandCentre::Command.new("PLACE 1,2,north") }

        it "delegates to robot passing args" do
          expect(subject.robot).to receive(:place).with("1,2,north")
          subject.execute
        end
      end

      context "with all other commands" do
        subject { CommandCentre::Command.new("move") }

        context "when not placed" do
          it "delegates to robot" do
            expect(IO).to receive(:popen)
            expect(subject.robot).not_to receive(:move)
            subject.execute
          end
        end

        context "when placed" do
          it "delegates to robot" do
            expect(subject.robot.table).to receive(:placed?).and_return(true)
            expect(subject.robot).to receive(:move)
            subject.execute
          end
        end
      end
    end
  end

  describe "#execute_from_file" do
    it "reads lines and executes them" do
      expect(IO).to receive(:readlines).and_return(["place 1,2,north"])
      expect(subject).to receive(:parse_and_execute)
      subject.execute_from_file("fake_file_path.txt")
    end
  end
end
