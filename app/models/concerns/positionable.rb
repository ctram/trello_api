module Positionable
  def ensure_position_exists
    update(position: siblings.length) if position.nil?
  end

  # no-op, method must be defined in extended class
  def siblings
    raise 'siblings method must be defined in extended class'
  end

  def valid_position
    items_length = siblings.length + 1
    return if position <= items_length - 1 && position >= 0
    errors.add(:position, "must be within range of 0 and #{items_length - 1}")
  end

  def update_sibling_positions
    orig_position, new_position = position_previous_change
    num_items = siblings.length
  
    if new_position < 0
      new_position = 0
    elsif new_position > num_items
      new_position = num_items
    end
  
    return true if new_position == orig_position
  
    if new_position > orig_position
      start_idx = orig_position + 1
      end_idx = new_position
      type = :decrement
    else
      start_idx = new_position
      end_idx = orig_position - 1
      type = :increment
    end

    return true if start_idx > siblings.length - 1 && start_idx < 0
    raise 'Start index cannot be larger than end index' if start_idx > end_idx
    siblings.where(position: start_idx..end_idx).each do |sibling|
      new_position = type == :decrement ? sibling.position - 1 : sibling.position + 1
      sibling.update!(position: new_position)
    end
  end
end
