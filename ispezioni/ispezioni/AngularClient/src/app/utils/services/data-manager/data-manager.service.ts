import { EventEmitter } from '@angular/core';
import {
  DataPaginator,
  DataFilter,
  DataTextFilter,
  DataDateFilter,
  DataSelectionFilter,
  DataSorter,
  DataReflex,
  FilterConf,
  SelectionFilterConf,
  SorterConf,
  DataReflexMappingFunction,
  dataReflexDefaultMapping,
} from '.';
import { isDeeplyEqual } from '../../lib';
import { DataNumberFilter } from './controls/filters/data-number.filter';
import { DataMasterSelector } from './controls/selectors/data-master-selector';
import { DataSelector } from './controls/selectors/data-selector';

//requires an array of generic data to work on
export class DataManagerService {
  private _data: any[] = [];
  private _dataReflex: DataReflex[] = []; //reflects data
  private _filters: DataFilter[] = [];
  private _sorters: DataSorter[] = [];
  private _activeSorters: DataSorter[] = []; //used to track which sorter has precedence
  private _selectors: DataSelector[] = [];
  private _masterSelector?: DataMasterSelector;
  private _paginator?: DataPaginator;

  //events
  dataChange = new EventEmitter();
  dataReflexChange = new EventEmitter();

  constructor() {}

  //factory methods
  createPaginator(itemsPerPage = 25) {
    this._paginator = new DataPaginator(this, itemsPerPage);
    return this._paginator;
  }

  createFilter(filterConf: FilterConf | SelectionFilterConf) {
    let filter: DataFilter;
    switch (filterConf.type) {
      case 'number':
        filter = new DataNumberFilter(this, filterConf);
        break;
      case 'date':
        filter = new DataDateFilter(this, filterConf);
        break;
      case 'selection':
        if ('values' in filterConf)
          filter = new DataSelectionFilter(this, filterConf);
        else throw new Error('Missing "values" in this filter configuration.');
        break;
      default:
        filter = new DataTextFilter(this, filterConf);
        break;
    }
    this.filters.push(filter);
    return filter;
  }

  createSorter(sorterConf: SorterConf) {
    let sorter = new DataSorter(this, sorterConf);
    this.sorters.push(sorter);
    return sorter;
  }

  //repository methods
  findFilter(field: string) {
    return this.filters.find((f) => f.field === field);
  }

  findSorter(field: string) {
    return this.sorters.find((s) => s.field === field);
  }

  findSelector(dataOrReflex: any) {
    if(!dataOrReflex) throw new Error('Provide a valid argument');
    let index = -1;
    if ('pointer' in dataOrReflex && typeof dataOrReflex.pointer === 'number')
      index = dataOrReflex.pointer;
    else
      index = this.data.findIndex((d) => isDeeplyEqual(d, dataOrReflex));
    return index >= 0 ? this.selectors[index] : undefined;
  }

  findData(dataReflex: DataReflex) {
    return this.data[dataReflex.pointer];
  }

  findReflex(data: any) {
    return this.dataReflex.find((ref) =>
      isDeeplyEqual(this.data[ref.pointer], data)
    );
  }

  //resetters
  resetAllFilters() {
    this.activeFilters.forEach((f) => {
      f.clean();
      f.reset(true);
    });
    this.dataReflex = this.data.map(dataReflexDefaultMapping);
  }

  resetAllSorters() {
    this._activeSorters.forEach((s) => (s.sortOrder = 'none'));
    this._activeSorters = [];
    this.dataReflex = this.dataReflex.sort((a, b) => a.pointer - b.pointer);
  }

  //computed props
  get selectedData() {
    return this.dataReflex
      .filter((ref) => ref.selected)
      .map(this.findData, this);
  }

  //getters & setters
  get data() {
    return this._data;
  }

  set data(newData) {
    this._data = newData;
    //resetting controls
    this._filters.forEach((f) => f.reset());
    this._sorters.forEach((s) => s.reset());
    this._activeSorters = [];
    //emitting change
    this.dataChange.emit();
    this.dataReflex = this.data.map(dataReflexDefaultMapping);
  }

  get dataReflex() {
    return this._dataReflex;
  }

  set dataReflex(value) {
    this._dataReflex = value;
    //init selectors
    this._selectors = this.dataReflex.map((reflex) => {
      let selector = new DataSelector(this, reflex);
      if (this.data[reflex.pointer].disabled) selector.disable();
      return selector;
    }, this);
    this._masterSelector = new DataMasterSelector(this);
    this.dataReflexChange.emit();
  }

  get filters() {
    return this._filters;
  }

  get sorters() {
    return this._sorters;
  }

  get selectors() {
    return this._selectors;
  }

  get masterSelector() {
    return this._masterSelector;
  }

  get activeFilters() {
    return this.filters.filter((f) => f.isActive);
  }

  get activeSorters() {
    return this._activeSorters;
  }

  get paginator() {
    return this._paginator;
  }

  get content() {
    return this.paginator
      ? this.paginator.currentPage.content
      : this.dataReflex;
  }
}
