require 'rails_helper'
require_relative '../../app/models/column'
require_relative '../shared/examples/CRUD_actions'
require_relative '../shared/contexts/authorization_headers'

RSpec.describe 'Columns', type: :request do
  include_examples 'CRUD actions', Column, :board
  include_context 'authorization headers'

  describe 'position order' do
    let(:board) { FactoryBot.create :board }

    before(:example) do
      5.times do |idx|
        column = FactoryBot.build :column
        column.update(board_id: board.id, name: "prev #{idx}")
      end
    end


    it 'cannot move below position 0' do
      column = board.columns[2]
      put column_url(column), params: { column: { position: -1 } }, headers: authorization_headers
      expect(response).to have_http_status(422)
    end

    it 'cannot move to position greater than list length' do
      column = board.columns[2]
      put column_url(column), params: { column: { position: 5 } }, headers: authorization_headers
      expect(response).to have_http_status(422)
    end

    it 'moves from 2 to 0 and its sibling positions are updated' do
      column = board.columns[2]
      put column_url(column), params: { column: { position: 0 } }, headers: authorization_headers
      columns = board.columns.reload
      expect(response).to have_http_status(200)
      expect(columns[0].name).to eq('prev 2')
      expect(columns[1].name).to eq('prev 0')
      expect(columns[2].name).to eq('prev 1')
      expect(columns[3].name).to eq('prev 3')
      expect(columns[4].name).to eq('prev 4')
      expect(JSON.parse(response.body)['position']).to eq(0)
    end

    it 'moves from 4 to 0 and its sibling positions are updated' do
      column = board.columns[4]
      put column_url(column), params: { column: { position: 0 } }, headers: authorization_headers
      columns = board.columns.reload
      expect(response).to have_http_status(200)
      expect(columns[0].name).to eq('prev 4')
      expect(columns[1].name).to eq('prev 0')
      expect(columns[2].name).to eq('prev 1')
      expect(columns[3].name).to eq('prev 2')
      expect(columns[4].name).to eq('prev 3')
      expect(JSON.parse(response.body)['position']).to eq(0)
    end

    it 'moves from 0 to 4 and its sibling positions are updated' do
      column = board.columns[0]
      put column_url(column), params: { column: { position: 4 } }, headers: authorization_headers
      columns = board.columns.reload
      expect(response).to have_http_status(200)
      expect(columns[0].name).to eq('prev 1')
      expect(columns[1].name).to eq('prev 2')
      expect(columns[2].name).to eq('prev 3')
      expect(columns[3].name).to eq('prev 4')
      expect(columns[4].name).to eq('prev 0')
      expect(JSON.parse(response.body)['position']).to eq(4)
    end
  end
end
