
$(function(){

	
	 var pagerOptions = {
			    // target the pager markup - see the HTML block below
			    container: $(".pager"),
			    // output string - default is '{page}/{totalPages}'; possible variables: {page}, {totalPages}, {startRow}, {endRow} and {totalRows}
			    output: '{startRow} - {endRow} / {filteredRows} ({totalRows})',
			    // if true, the table will remain the same height no matter how many records are displayed. The space is made up by an empty
			    // table row set to a height to compensate; default is false
			    fixedHeight: true,
			    // remove rows from the table to speed up the sort of large tables.
			    // setting this to false, only hides the non-visible rows; needed if you plan to add/remove rows with the pager enabled.
			    removeRows: false,
			    // go to page selector - select dropdown that sets the current page
			    cssGoto: '.gotoPage'
			  };

	 
	  $('.tablesorter').tablesorter({
	    theme: 'blue',
	    widthFixed : true,
	    showProcessing: true,
	    headerTemplate : '{content} {icon}',
	    widgets: [  'zebra', 'filter' ]
	  }).tablesorterPager(pagerOptions);

	});


