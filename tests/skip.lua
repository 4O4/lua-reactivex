local Observable = require("reactivex.observable")
local Observer = require("reactivex.observer")
local Subscription = require("reactivex.subscription")

require('reactivex.operators.skip')

describe('skip', function()
  it('produces an error if its parent errors', function()
    createSingleUseOperator(
      "simulateError", 
      function (destination)
        destination:onError()
      end
    )
    local observable = Observable.of(''):simulateError()
    expect(observable).to.produce.error()
    expect(observable:skip(1)).to.produce.error()
  end)

  it('produces all values if the count is zero', function()
    local observable = Observable.fromTable({2, 3, 4}, ipairs):skip(0)
    expect(observable).to.produce(2, 3, 4)
  end)

  it('produces all values if the count is less than zero', function()
    local observable = Observable.fromTable({2, 3, 4}, ipairs):skip(-3)
    expect(observable).to.produce(2, 3, 4)
  end)

  it('skips one element if no count is specified', function()
    local observable = Observable.fromTable({2, 3, 4}, ipairs):skip()
    expect(observable).to.produce(3, 4)
  end)

  it('produces no values if it skips over all of the values of the original', function()
    local observable = Observable.fromTable({1, 2}, ipairs):skip(2)
    expect(observable).to.produce.nothing()
  end)

  it('completes and does not fail if it skips over more values than were produced', function()
    local observable = Observable.of(3):skip(5)
    local onNext, onError, onCompleted = observableSpy(observable)
    expect(#onNext).to.equal(0)
    expect(#onError).to.equal(0)
    expect(#onCompleted).to.equal(1)
  end)

  it('produces the elements it did not skip over', function()
    local observable = Observable.fromTable({4, 5, 6}, ipairs):skip(2)
    expect(observable).to.produce(6)
  end)
end)
