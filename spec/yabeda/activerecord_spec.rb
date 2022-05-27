# frozen_string_literal: true

RSpec.describe Yabeda::ActiveRecord do
  it "has a version number" do
    expect(Yabeda::ActiveRecord::VERSION).not_to be nil
  end

  describe "query performance metrics" do
    subject { TestModel.first }

    it "increments counters for this model" do
      expect { subject }.to \
        increment_yabeda_counter(Yabeda.activerecord.queries_total)
        .with_tags(kind: "TestModel Load")
        .by(1)
    end

    context "for model in another db" do
      subject { AnotherDbTestModel.first }

      it "increments labels for it" do
        expect { subject }.to \
          increment_yabeda_counter(Yabeda.activerecord.queries_total)
          .with_tags(kind: "AnotherDbTestModel Load")
          .by(1)
      end
    end
  end

  describe "connection pool stats" do
    subject { Yabeda.collect! }

    it "measures pool size" do
      expect { subject }.to \
        update_yabeda_gauge(Yabeda.activerecord.connection_pool_size)
        .with_tags(config: "primary")
        .with(5)
    end
  end
end
