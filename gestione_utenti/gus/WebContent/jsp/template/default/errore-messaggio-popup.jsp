<%@ taglib uri="/WEB-INF/ustl.tld" prefix="us" %>

<div id="dialog-error-message" title="Attenzione">
	<p>
		<us:err classe="errore" />
 		<us:mex classe="messaggio" />
 	</p>
</div>

<script type="text/javascript">
	$(function() {
		// a workaround for a flaw in the demo system (http://dev.jqueryui.com/ticket/4375), ignore!
		//$( "#dialog:ui-dialog" ).dialog( "destroy" );

		$( "#dialog-error-message" ).dialog({
			//height: 140,
			modal: true,
			autoOpen: true,
			closeOnEscape: true,
			show: 'blind',
			resizable: false,
			draggable: false,
			//width: 350,
			buttons: {
				"Chiudi": function() {
					$( this ).dialog( "close" );
				}
			}
		});
	});
</script>
