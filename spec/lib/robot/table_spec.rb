describe Robot::Table do
  # ensure fresh singleton for each spec
  subject(:table) { Singleton.__init__(Robot::Table).instance }

  describe '#place' do
    context 'with valid position' do
      it 'sets position on table' do
        table.place('1', '2')
        expect(table.placed?).to be
        expect(table.position).to eq(x: 1, y: 2)
      end
    end
    context 'with invalid position' do
      it 'does not set position' do
        table.place('-1', '7')
        expect(table.placed?).not_to be
        expect(table.position).to be_nil
      end
    end
  end

  describe '#placed?' do
    it 'is false when not placed yet' do
      expect(table.placed?).not_to be
    end
    it 'is true when has position' do
      table.place('1', '2')
      expect(table.placed?).to be
    end
  end

  describe '#valid_position?' do
    context 'with invalid position coordinates' do
      let(:position) do
        {
          x: -1,
          y: 10
        }
      end
      it 'returns false' do
        expect(table.valid_position?(position)).not_to be
      end
    end
    context 'with all valid position coordinates' do
      it 'returns true' do
        5.times do |x|
          5.times do |y|
            expect(table.valid_position?(x: x, y: y)).to be
          end
        end
      end
    end
  end
end
