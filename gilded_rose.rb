class ItemDecrease
  def initialize(item)
    @item = item
  end

  def update
    @item.quality -= 1
    @item.sell_in -= 1
  end
end

class AgedBrieDecrease < ItemDecrease
  def update
    @item.sell_in -= 1
    return if @item.quality >= 50
    @item.quality += 1
  end
end

class BackstageDecrease < AgedBrieDecrease
  def update
    @item.sell_in -= 1

    if @item.sell_in.zero?
      @item.quality = 0
    elsif @item.sell_in < 5
      @item.quality += 3
    elsif @item.sell_in <= 10
      @item.quality += 2
    else
      @item.quality += 1
    end
  end
end

class SulfurasDecrease < ItemDecrease
  def update
  end
end

EXCEPTIONS = {
  "Aged Brie" => AgedBrieDecrease,
  "Backstage passes to a TAFKAL80ETC concert" => BackstageDecrease,
  "Sulfuras, Hand of Ragnaros" => SulfurasDecrease
}.freeze

class GildedRose
  def initialize(items)
    @items = items
  end

  def update_quality()
    @items.each do |item|
      if EXCEPTIONS.keys.include? item.name
        EXCEPTIONS[item.name].new(item).update
      else
        ItemDecrease.new(item).update
      end
    end
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
