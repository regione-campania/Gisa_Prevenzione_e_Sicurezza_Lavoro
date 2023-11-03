export interface User {
  nome: string;
  cognome: string;
  cf: string;
  idUtente: number | string;
  ruoloUtente: string;
  idAslUtente: number | string;
  idAmbito: number | string;
  endpoint: string[];
  iat: number;
  exp: number;
}
