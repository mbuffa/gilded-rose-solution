require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  describe "#update_quality" do
    context 'with a pristine sellIn property' do
      let(:item) { Item.new('foo', 10, 50) }

      it "doesn't change quality" do
        expect {
          GildedRose.new([item])
        }.not_to change { item.quality }
      end
    end

    context 'when sellIn is over' do
      context 'with a normal item' do
        let(:item) { Item.new('foo', 10, 50) }

        it 'degrades quality twice as fast' do
          expect {
            GildedRose.new([item]).update_quality
          }.to change { item.quality }.by(-1)
        end
      end

      context 'with sulfuras' do
        let(:item) { Item.new("Sulfuras, Hand of Ragnaros", 0, 80) }

        it 'degrades quality twice as fast' do
          expect {
            GildedRose.new([item]).update_quality
          }.not_to change { item.quality }
        end
      end

      context 'with aged brie' do
        context 'with an aged brie of 10 days' do
          let(:item) { Item.new("Aged Brie", 10, 10) }

          it {
            expect {
              gilded = GildedRose.new([item])
              gilded.update_quality
            }.to change { item.quality }.by(1)
          }
        end

        context 'with a starting quality of 50' do
          let(:item) { Item.new("Aged Brie", 10, 50) }

          it {
            expect {
              gilded = GildedRose.new([item])
              gilded.update_quality
            }.not_to change { item.quality }
          }
        end
      end

      context 'with backstage passes' do
        context 'with a starting quality of 10' do
          let(:item) { Item.new("Backstage passes to a TAFKAL80ETC concert", 10, 10) }

          it 'degrades quality twice as fast' do
            expect {
              gilded = GildedRose.new([item])
              4.times { gilded.update_quality }
            }.to change { item.quality }.by(8)
          end

          it 'degrades quality thrice as fast' do
            expect {
              gilded = GildedRose.new([item])
              5.times { gilded.update_quality }
              gilded.update_quality
            }.to change { item.quality }.by(13)
          end
        end
      end
    end

  end

end
