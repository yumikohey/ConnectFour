require "spec_helper"

describe Board, "Connect Four" do
	let(:board) {Board.new(7,7)}

	it "testing board.player_turn(:first) method" do
		no_empty = false
		board.player_turn(:first)[6].each do |ele|
			no_empty = true if ele != " "
		end
		expect(no_empty).to be_truthy
	end
end