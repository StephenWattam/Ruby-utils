
# Provide a nice truncated output for summaries
class String
  def truncate(lim, ellipsis='...', pad=' ')
    ellipsis = '' if self.length <= lim
    return ellipsis[ellipsis.length - lim..-1] if lim <= ellipsis.length
    return self[0..(lim - ellipsis.length)-1] + ellipsis + (pad * [lim - self.length, 0].max)
  end




  def demerau_levenshtein_distance(b)
    # Many thanks to http://davefancher.com/tag/damerau-levenshtein-distance/
    # whence this algorithm.

    a = self

    # 2D array axb
    mx = []
    (a.length + 1).times { mx << ([0] * (b.length + 1)) }

    (a.length + 1).times do |i|
      (b.length + 1).times do |j|

        if [i, j].include?(0)
          # Fill first row/col with 0s
          mx[i][j] = 0
        else
          # Assign current chars for easier use
          ac, bc = a[i - 1], b[j - 1]

          cost          = (ac == bc) ? 0 : 1

          # Get cost of operations from matrix
          ops = []
          ops << mx[i][j - 1]      + 1      # Insertion
          ops << mx[i - 1][j]      + 1      # Deletion
          ops << mx[i - 1][j - 1]  + cost   # Substitution

          # And find minimum
          distance      = ops.min

          # Check for transposition
          if i > 1 && j > 1 && ac == b[j - 2] && a[i - 2] == bc
            mx[i][j] = [distance, mx[i - 2][j - 2] + cost].min
          else
            mx[i][j] = distance
          end
        end

      end
    end

    return mx[a.length][b.length]

  end


end


