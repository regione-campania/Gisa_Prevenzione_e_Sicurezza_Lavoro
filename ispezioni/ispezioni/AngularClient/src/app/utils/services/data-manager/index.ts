export { DataControl } from './controls/data-control';
export { DataPaginator } from './controls/data-paginator';
export { DataFilter } from './controls/filters/data-filter';
export { DataTextFilter } from './controls/filters/data-text-filter';
export { DataDateFilter } from './controls/filters/data-date-filter';
export { DataSelectionFilter } from './controls/filters/data-selection-filter';
export { DataSorter } from './controls/data-sorter';
export { DataSelector } from './controls/selectors/data-selector';

//interfaces
export interface FilterConf {
  field: string; //the field this filter controls
  type: FilterType;
}

export interface SelectionFilterConf extends FilterConf {
  values: any[];
}

export interface SorterConf {
  field: string; //the field this sorter controls
  type: SorterType;
}

export interface DataReflex {
  pointer: number;
  visible: boolean;
  selected: boolean;
}

export interface DataPage {
  content: DataReflex[];
  pageNumber: number;
}

export interface DataSelectorInterface {
  data?: any;
  dataReflex?: DataReflex;
  value: boolean;
  disabled: boolean;
  select(): void;
  unselect(): void;
  toggle(): void;
  enable(): void;
  disable(): void;
}

export interface NumberFilterSingleConf {
  op: ComparisonOperator;
  value: number;
}

export interface NumberFilterRangeConf {
  lowerBound: number;
  upperBound: number;
}

//types aliases
export type FilterType = 'text' | 'number' | 'date' | 'selection';

export type TextFilterOption =
  | 'contains'
  | 'not-contains'
  | 'starts-with'
  | 'ends-with';

export type DateFilterOption =
  | 'exact-date'
  | 'from-date'
  | 'till-date'
  | 'range';

export type NumberFilterMode = 'single' | 'range';

export type NumberFilterConf = NumberFilterSingleConf | NumberFilterRangeConf;

export type ComparisonOperator = '=' | '!=' | '<' | '<=' | '>' | '>=';

export type SorterType = 'text' | 'number' | 'date';

export type SortOrder = 'none' | 'asc' | 'desc';

export type SelectorType = 'single' | 'multi';

export type DataReflexMappingFunction = {
  (data: any, index: number): DataReflex;
}

export const dataReflexDefaultMapping: DataReflexMappingFunction =
  function (data: any, index: number): DataReflex {
    return {
      pointer: index,
      visible: true,
      selected: data.selected ?? false,
    };
  };
