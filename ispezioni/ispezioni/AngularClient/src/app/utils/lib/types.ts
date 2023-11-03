export interface BackendResponse {
  esito: boolean;
  valore: any;
  msg: string | null;
  info: any;
}

export interface SheetApi {
  nome_foglio: string;
  intestazione_colonne: string[];
  dati: any[][];
}
