function selezionaFunzioneInModificaRuolo( chooser, ruolo )
{
	var choice		= chooser.options[ chooser.selectedIndex ].value;
	location.href	= 'ruoli.ToPermissionEdit.us?funzione=' + choice + '&ruolo=' + ruolo;
};

function selezionaFunzioneInGestioneFunzioni( chooser )
{
	var choice		= chooser.options[ chooser.selectedIndex ].value;
	location.href	= 'funzioni.ToPermissionEdit.us?funzione=' + choice;
};

function setAllRO()
{
	var zip = document.getElementsByTagName( "input" );
	for( var i = 0; i < zip.length; i++ )
	{
		if( zip[i].id == "ogRadio" && zip[i].value == 0 )
		{
			zip[i].checked = true;
		}
	}
};

function setAllRW()
{
	var zip = document.getElementsByTagName( "input" );
	for( var i = 0; i < zip.length; i++ )
	{
		if( zip[i].id == "ogRadio" && zip[i].value == 1 )
		{
			zip[i].checked = true;
		}
	}
};

function setAllNO()
{
	var zip = document.getElementsByTagName( "input" );
	for( var i = 0; i < zip.length; i++ )
	{
		if( zip[i].id == "ogRadio" && zip[i].value == 2 )
		{
			zip[i].checked = true;
		}
	}
};
