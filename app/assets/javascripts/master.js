function dragDrop() {
  $(".chessPiece").draggable({
    containment: "#board",
    //cursor: "move", play with this to make the cursor at the bottom of the piece, this might make it easier to see what's happening on a smaller device
    revert: true,
  });

  $(".square").droppable({
    drop: handleDragStop,
    hoverClass: "hoveredSquare"
  });
}

function handleDragStop( event, ui ) {
  ui.draggable.draggable( 'option', 'revert', false );
  ui.draggable.position({ 
    of: $(this), 
    my: 'left top', 
    at: 'left top' 
    });
  var destination_x = $(this).data("x");
  var destination_y = $(this).data("y");

  $.ajax({
    type: 'PATCH',
    url: ui.draggable.data('url'),
    dataType: 'script', //no touchy
    data: { piece: { x_coord: destination_x, y_coord: destination_y } }
  });
}
