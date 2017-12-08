# frozen_string_literal: true

Facter.add(:swapoff) do
  setcode do
    meminfo = Facter.value("meminfo")

    meminfo['SwapTotal'].zero? && meminfo['SwapFree'].zero?
  end
end
