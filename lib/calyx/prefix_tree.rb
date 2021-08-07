module Calyx
  PrefixNode = Struct.new(:children, :index)
  PrefixEdge = Struct.new(:node, :label, :wildcard?)
  PrefixMatch = Struct.new(:label, :index, :captured)

  class PrefixTree
    def initialize
      @root = PrefixNode.new([], nil)
    end

    def insert(label, index)
      if @root.children.empty?
        @root.children << PrefixEdge.new(PrefixNode.new([], index), label, false)
      end
    end

    def add_all(elements)
      elements.each_with_index { |el, i| add(el, i) }
    end

    def add(label, index)
      parts = label.split(/(%)/).reject { |p| p.empty? }
      parts_count = parts.count

      # Can’t use more than one capture symbol which gives the following splits:
      # - ["literal"]
      # - ["%", "literal"]
      # - ["literal", "%"]
      # - ["literal", "%", "literal"]
      if parts_count > 3
        raise "Too many capture patterns: #{label}"
      end

      current_node = @root

      parts.each_with_index do |part, i|
        index_slot = (i == parts_count - 1) ? index : nil
        is_wildcard = part == "%"
        matched_prefix = false

        current_node.children.each_with_index do |edge, j|
          prefix = common_prefix(edge.label, part)
          unless prefix.empty?
            matched_prefix = true

            if prefix == edge.label
              # Current prefix matches the edge label so we can continue down the
              # tree without mutating the current branch
              next_node = PrefixNode.new([], index_slot)
              current_node.children << PrefixEdge.new(next_node, label.delete_prefix(prefix), is_wildcard)
            else
              # We have a partial match on current edge so replace it with the new
              # prefix then rejoin the remaining suffix to the existing branch
              edge.label = edge.label.delete_prefix(prefix)
              prefix_node = PrefixNode.new([edge], nil)
              next_node = PrefixNode.new([], index_slot)
              prefix_node.children << PrefixEdge.new(next_node, label.delete_prefix(prefix), is_wildcard)
              current_node.children[j] = PrefixEdge.new(prefix_node, prefix, is_wildcard)
            end

            current_node = next_node
            break
          end
        end

        # No existing edges have a common prefix so push a new branch onto the tree
        # at the current level
        unless matched_prefix
          next_edge = PrefixEdge.new(PrefixNode.new([], index_slot), part, is_wildcard)
          current_node.children << next_edge
          current_node = next_edge.node
        end
      end
    end

    # This was basically ported from the pseudocode found on Wikipedia to Ruby,
    # with a lot of extra internal state tracking that is totally absent from
    # most algorithmic descriptions. This ends up making a real mess of the
    # expression of the algorithm, mostly due to choices and conflicts between
    # whether to go with the standard iterative and procedural flow of statements
    # or use a more functional style. A mangle that speaks to the questions
    # around portability between different languages. Is this codebase a design
    # prototype? Is it an evolving example that should guide implementations in
    # other languages?
    #
    # The problem with code like this is that it’s a bit of a maintenance burden
    # if not structured compactly and precisely enough to not matter and having
    # enough tests passing that it lasts for a few years without becoming a
    # nuisance or leading to too much nonsense.
    #
    # There are several ways to implement this, some of these may work better or
    # worse, and this might be quite different across multiple languages so what
    # goes well in one place could suck in other places. The only way to make a
    # good decision around it is to learn via testing and experiments.
    #
    # Alternative possible implementations:
    # - Regex compilation on registration, use existing legacy mapping code
    # - Prefix tree, trie, radix tree/trie, compressed bitpatterns, etc
    # - Split string flip, imperative list processing hacks
    #   (easier for more people to contribute?)
    def lookup(label)
      current_node = @root
      chars_consumed = 0
      chars_captured = nil
      label_length = label.length

      # Traverse the tree until reaching a leaf node or all input characters are consumed
      while current_node != nil && !current_node.children.empty? && chars_consumed < label_length
        # Candidate edge pointing to the next node to check
        candidate_edge = nil

        # Traverse from the current node down the tree looking for candidate edges
        current_node.children.each do |edge|
          # Generate a suffix based on the prefix already consumed
          sub_label = label[chars_consumed, label_length]

          # If this edge is a wildcard we check the next level of the tree
          if edge.wildcard?
            # Wildcard pattern is anchored to the end of the string so we can
            # consume all remaining characters and pick this as an edge candidate
            if edge.node.children.empty?
              chars_captured = label[chars_consumed, sub_label.length]
              chars_consumed += sub_label.length
              candidate_edge = edge
              break
            end

            # The wildcard is anchored to the start or embedded in the middle of
            # the string so we traverse this edge and scan the next level of the
            # tree with a greedy lookahead. This means we will always match as
            # much of the wildcard string as possible when there is a trailing
            # suffix that could be repeated several times within the characters
            # consumed by the wildcard pattern.
            #
            # For example, we expect `"te%s"` to match on `"tests"` rather than
            # bail out after matching the first three characters `"tes"`.
            edge.node.children.each do |lookahead_edge|
              prefix = sub_label.rindex(lookahead_edge.label)
              if prefix
                chars_captured = label[chars_consumed, prefix]
                chars_consumed += prefix + lookahead_edge.label.length
                candidate_edge = lookahead_edge
                break
              end
            end
            # We found a candidate so no need to continue checking edges
            break if candidate_edge
          else
            # Look for a common prefix on this current edge label and the remaining suffix
            if edge.label == common_prefix(edge.label, sub_label)
              chars_consumed += edge.label.length
              candidate_edge = edge
              break
            end
          end
        end

        if candidate_edge
          # Traverse to the node our edge candidate points to
          current_node = candidate_edge.node
        else
          # We didn’t find a possible edge candidate so bail out of the loop
          current_node = nil
        end
      end

      # In order to return a match, the following postconditions must be true:
      # - We are pointing to a leaf node
      # - We have consumed all the input characters
      if current_node != nil and current_node.index != nil and chars_consumed == label_length
        PrefixMatch.new(label, current_node.index, chars_captured)
      else
        nil
      end
    end

    def common_prefix(a, b)
      selected_prefix = ""
      min_index_length = a < b ? a.length : b.length
      index = 0

      until index == min_index_length
        return selected_prefix if a[index] != b[index]
        selected_prefix += a[index]
        index += 1
      end

      selected_prefix
    end
  end
end
