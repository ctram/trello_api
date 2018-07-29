module Positionable
  def ensure_position_exists
    update(position: siblings.length) if position.nil?
  end

  def siblings
    raise 'siblings method must be defined'
  end

  def update_sibling_positions(new_position)
    raise ArgumentError, 'Argument must be an integer' unless new_position.is_a?(Integer)
    orig_position = position
    num_items = siblings.length
  
    if new_position < 0
      new_position = 0
    elsif new_position > num_items - 1
      new_position = num_items - 1
    end
  
    return true if new_position == position
  
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
      new_position = update_type == :decrement ? sibling.position - 1 : sibling.position + 1
      sibling.update!(:position, new_position)
    end
    true
  end
end
