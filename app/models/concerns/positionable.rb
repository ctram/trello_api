module Positionable
  def ensure_has_position
    update(position: siblings.length) if position.nil?
  end

  def siblings
    raise 'siblings method must be defined'
  end

  def move_to(new_position)
    raise ArgumentError, 'Position must be integer' unless position.is_a?(Integer)
    orig_position = position
    num_items = siblings.length

    if new_position < 0
      new_position = 0
    elsif new_position > num_items - 1
      new_position = num_items - 1
    end

    return true if new_position == position

    if new_position > orig_position
      update_position(orig_position + 1, new_position, :decrement)
    else
      update_position(new_position, orig_position - 1, :increment)
    end

    update(position: new_position)
  end

  def update_position(start_idx, end_idx, update_type = :decrement)
    return if start_idx > siblings.length - 1 && start_idx < 0
    
    raise ArgumentError, 'Indices must be integers' unless start_idx.is_a?(Integer) && end_idx.is_a?(Integer)
    raise 'Invalid update type' unless %i[decrement increment].include? update_type
    raise 'Start index cannot be larger than end index' if start_idx > end_idx
    siblings.where(position: start_idx..end_idx).each do |sibling|
      update_type == :decrement ? sibling.decrement(:position).save : sibling.increment(:position).save
    end
  end
end
