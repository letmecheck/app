function init() {
  $(".chessPiece").draggable({
    containment: ".board-booyah-box",
    cursor: "move",
    revert: true,
  });

  $(".square").droppable({
    drop: handleDragStop,
    hoverClass: "hoveredSquare"
  });
}

function handleDragStop( event, ui ) {
  ui.draggable.draggable( 'option', 'revert', false );
  var destination_x = $(this).data("x");
  var destination_y = $(this).data("y");
  $.ajax({
    type: 'PATCH',
    url: ui.draggable.data('update-url'),
    dataType: 'script',
    data: { piece: { x_coord: destination_x, y_coord: destination_y } }
  });
}