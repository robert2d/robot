describe Robot::CommandCentre do
  let(:command) { Robot::CommandCentre::Command }
  let(:commands) { Robot::CommandCentre::COMMANDS }

  subject { Singleton.__init__(described_class).instance }

  before do
    allow(subject).to receive(:puts)
  end

  describe '#parse_and_execute' do
    context 'invalid command' do
      let(:command) { double('Command') }

      it 'returns without executing' do
        expect(described_class::Command).to receive(:new).and_return(command)
        expect(command).to receive(:validate)
        expect(command).not_to receive(:execute)
        subject.parse_and_execute('test')
      end
    end

    context 'valid command' do
      it 'validates and executes command' do
        expect_any_instance_of(command).to receive(:execute)
        subject.parse_and_execute(commands.sample)
      end
    end
  end

  describe Robot::CommandCentre::Command do
    describe '#new' do
      subject { command }

      it 'constucts valid Command' do
        expect(subject.new('test')).to respond_to(:command, :args, :robot)
      end
    end

    describe '#validate' do
      context 'is invalid' do
        subject { command.new('test') }

        it 'returns false' do
          expect(subject.validate).not_to be
        end
      end

      context 'is valid' do
        subject { command.new(commands.sample) }

        it 'returns false' do
          expect(subject.validate).to be
        end
      end
    end

    describe '#execute' do
      context 'with PLACE command' do
        subject { command.new('PLACE 1,2,north') }

        it 'delegates to robot passing args' do
          expect(subject.robot).to receive(:place).with('1,2,north')
          subject.execute
        end
      end

      context 'with all other commands' do
        subject { command.new('move') }

        context 'when not placed' do
          it 'delegates to robot' do
            expect(Robot::CommandCentre.instance).to receive(:say)
            expect(subject.robot.table).to receive(:placed?)
            expect(subject.robot).not_to receive(:move)
            subject.execute
          end
        end

        context 'when placed' do
          it 'delegates to robot' do
            expect(subject.robot.table).to receive(:placed?).and_return(true)
            expect(subject.robot).to receive(:move)
            subject.execute
          end
        end
      end
    end
  end
end
