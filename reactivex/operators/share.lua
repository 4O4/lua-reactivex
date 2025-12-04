local Observable = require 'reactivex.observable'
require 'reactivex.operators.publish'
require 'reactivex.operators.refCount'

-- Convenience alias for publish():refCount(); makes a cold observable hot and
-- shared among subscribers without replaying past values.
function Observable:share()
  return self:publish():refCount()
end
