{ MetadataCollection } = require 'collections/metadata'

# Contains all of the Queries used by an ETflex scene.
class exports.Queries extends MetadataCollection
  model: require('models/query').Query
