describe Robot::Matrix do
  subject { described_class.new({ x: 1, y: 1 }, :north) }

  describe '#to_s' do
    let(:expected) do
      <<-TEXT.gsub(/^\s+/, '')
        X X X X X
        X X X X X
        X X X X X
        X ^ X X X
        X X X X X
      TEXT
    end
    it 'provides correct matrix for given inputs' do
      expect(subject.to_s).to eq(expected.strip)
    end
  end
end
