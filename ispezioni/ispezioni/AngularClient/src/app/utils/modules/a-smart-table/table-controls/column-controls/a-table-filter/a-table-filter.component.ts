import { Component, ElementRef, HostListener, Input, OnInit, ViewChild } from '@angular/core';
import { DataFilter, FilterType } from 'src/app/utils/services/data-manager';
import { ASmartTableComponent } from '../../../a-smart-table.component';
import { AColumnControl } from '../a-column-control.directive';

@Component({
  selector: 'a-table-filter',
  templateUrl: './a-table-filter.component.html',
  styleUrls: ['./a-table-filter.component.scss'],
})
export class ATableFilterComponent extends AColumnControl implements OnInit {
  @ViewChild('filterComponent') filterComponent?: any;
  @Input() type: FilterType = 'text';
  @Input() values?: any; //used with 'selection' filters

  protected _filter?: DataFilter;
  isVisible = false;

  constructor(protected override aSmartTable: ASmartTableComponent, protected elementRef: ElementRef) {
    super(aSmartTable);
  }

  ngOnInit(): void {
    if(!this.field)
      throw new Error('Provide a valid field for this filter');
    let filterConf: any = {field: this.field, type: this.type};
    if(this.values)
      filterConf.values = this.values;
    this._filter = this.dm.createFilter(filterConf);
  }

  apply() {
    this.filterComponent?.filter?.apply();
  }

  reset() {
    this.filterComponent?.filter?.reset();
  }

  clean() {
    this.filterComponent?.filter?.clean();
  }

  toggle(): void {
    this.isVisible ? this.hide() : this.show();
  }

  show(): void {
    this.tableFilters.find((f) => f.isVisible)?.hide();
    this.isVisible = true;
    setTimeout(() => this._updatePosition(), 0);
    window.addEventListener('click', this.windowClickListener);
  }

  hide(): void {
    this.isVisible = false;
    window.removeEventListener('click', this.windowClickListener);
  }

  @HostListener('click', ['$event']) onClick(e: Event) {
    e.stopPropagation();
  }

  onKeyDown(e: KeyboardEvent) {
    e.stopPropagation();
    if (e.key === 'Enter') {
      e.preventDefault();
      this.apply();
      this.hide();
    } else if (e.key === 'Escape') this.hide();
  }

  //prevents filter template's overflow
  private _updatePosition() {
    const filterTemplate =
      this.elementRef.nativeElement.querySelector('.filter-template');
    if (filterTemplate) {
      const filterBox = filterTemplate.getBoundingClientRect();
      const tableBox =
        this.aSmartTable.table?.nativeElement.getBoundingClientRect();
      if (filterBox.right >= tableBox.right) filterTemplate.style.right = '0';
      else if (filterBox.left <= tableBox.left) filterTemplate.style.left = '0';
    }
  }

  //getters & setters
  protected get tableFilters() {
    return this.aSmartTable.controls.filter(
      (c) => c.constructor === ATableFilterComponent
    ) as ATableFilterComponent[];
  }

  get filter() {
    return this._filter;
  }

  get isActive() {
    return this.filterComponent?.filter?.isActive ?? false;
  }

  protected get windowClickListener() {
    return () => this.hide();
  }
}
