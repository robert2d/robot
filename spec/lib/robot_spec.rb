describe Robot do
  let(:position) do
    {
      x: 1,
      y: 2
    }
  end

  # ensure fresh singleton for each spec
  subject(:robot) { Singleton.__init__(Robot).instance }

  before do
    allow(robot).to receive(:puts)
  end

  it 'has a version' do
    expect(Robot::VERSION).to be
  end

  describe 'relationship to table' do
    it 'should create relationship to table' do
      expect(robot).to respond_to(:table)
      expect(robot.table).to be_an_instance_of(Robot::Table)
    end
  end

  describe '#move' do
    context 'with valid placement on table' do
      it 'returns valid placement' do
        expect(robot).to receive(:new_position).and_return(position)
        expect(robot.table).to receive(:place).and_call_original
        expect(Robot::CommandCentre.instance).not_to receive(:say)
        robot.move
      end
    end

    context 'invalid placement on table' do
      it 'alerts user of failed move' do
        expect(robot).to receive(:new_position).and_return(position)
        expect(robot.table).to receive(:place)
        expect(Robot::CommandCentre.instance).to receive(:say)
        robot.move
      end
    end
  end

  describe '#new_position' do
    it 'fetches coordinates for move' do
      expect(robot.table).to receive(:position).and_return(position)
      expect(robot).to receive(:move_coordinates).and_return(position)
      expect(robot.send(:new_position)).to eq(x: 2, y: 4)
    end
  end

  describe '#to_s' do
    it 'provides position and direction in string' do
      robot.send(:direction=, :north)
      allow(robot.table).to receive(:position).and_return(position)
      expect(robot.to_s).to eq('1, 2 NORTH')
    end
  end

  describe '#move_coordinates' do
    it 'returns coords from current face' do
      robot.send(:direction=, :north)
      expect(robot.send(:move_coordinates)).to eq(x: 0, y: 1)
    end
  end

  describe '#right' do
    it 'returns correct face clockwise' do
      robot.send(:direction=, :north)
      expect(robot).to receive(:direction=).with(:east)
      expect(robot.right).to eq(:east)
    end
  end

  describe '#left' do
    it 'returns correct face anti-clockwise' do
      robot.send(:direction=, :west)
      expect(robot).to receive(:direction=).with(:south)
      expect(robot.left).to eq(:south)
    end
  end

  describe '#report' do
    let(:table) { double(Robot::Table, position: { x: 1, y: 2 }) }

    it 'outputs text and calls say' do
      expect(robot).to receive(:direction).exactly(3).times.and_return(:north)
      allow(robot).to receive(:table).and_return(table)
      expect(Robot::CommandCentre.instance).to receive(:say)
      robot.report
    end
  end

  describe '#place' do
    context 'with invalid args' do
      it 'does nothing with nil args' do
        expect(robot.table).not_to receive(:place)
        robot.place(nil)
      end

      it 'does nothing with blank string' do
        expect(robot.table).not_to receive(:place)
        robot.place('        ')
      end

      it 'does nothing with malformed args' do
        expect(robot.table).not_to receive(:place)
        robot.place('1,2north')
        robot.place('north')
      end
    end

    context 'with valid args' do
      context 'and valid placement' do
        it 'sets direction' do
          expect(robot.table).to receive(:place).with(
            '1', '2'
          ).and_call_original
          expect(robot).to receive(:direction=).with(:north)
          robot.place('1,2,north')
        end
      end

      context 'and invalid placement' do
        it 'does not set direction when place fails' do
          expect(robot.table).to receive(:place).with('1', '2')
          expect(robot).not_to receive(:direction=)
          robot.place('1,2,north')
        end
      end
    end
  end

  describe '#direction=' do
    context 'direction is invalid' do
      it 'does not save position' do
        robot.send(:direction=, :up)
        expect(robot.direction).not_to be
      end
    end
    context 'direction is valid' do
      it 'does save to singleton' do
        robot.send(:direction=, :west)
        expect(robot.direction).to eq(:west)
      end
    end
  end
end
