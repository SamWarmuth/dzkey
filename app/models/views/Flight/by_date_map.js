function(doc) {
  if(doc.jump_date) {
    emit(doc.jump_date, null);
  }
}