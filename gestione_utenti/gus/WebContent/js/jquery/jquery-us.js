$(function() {
	// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
//	$( "#dialog:ui-dialog" ).dialog( "destroy" );

	$( "#dialog-modal" ).dialog({
		height: 140,
		modal: true,
		autoOpen: false,
		closeOnEscape: false,
		show: 'blind',
		resizable: false,
		draggable: false,
		width: 250
	});
});

function attendere()
{
	$( "#dialog-modal" ).dialog( "open" );
};

function myConfirm( testo )
{
	if( confirm( testo ) )
	{
		attendere();
		return true;
	}
	else
	{
		return false;
	}
};
	