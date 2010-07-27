class Rig < CouchRest::ExtendedDocument
  property :name
  property :type
  
  property :last_main_repack #or next needed? Are all packs the same?
  property :last_reserve_repack #or next needed.
end