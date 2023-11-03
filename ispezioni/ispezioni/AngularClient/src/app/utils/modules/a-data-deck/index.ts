import { FilterConf, SorterConf } from "../../services/data-manager";

interface ADataDeckFilterConf extends FilterConf {
  label: string;   //label of the key to display
  values?: any[];  //used with selection fiters
}

interface ADataDeckSorterConf extends SorterConf {
  label: string;   //label of the key to display
}

export { ADataDeckFilterConf, ADataDeckSorterConf };
