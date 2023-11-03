import {
  Component,
  ElementRef,
  Input,
  OnInit,
  ViewChild,
} from '@angular/core';
import { DataPaginator } from 'src/app/utils/services/data-manager';
import { ATableControl } from '../a-table-control.directive';

@Component({
  selector: 'a-table-paginator',
  templateUrl: './a-table-paginator.component.html',
  styleUrls: ['./a-table-paginator.component.scss'],
})
export class ATablePaginatorComponent extends ATableControl implements OnInit {
  @Input() rowsPerPage: 10 | 25 | 50 | 100 = 25;
  paginator?: DataPaginator;

  ngOnInit() {
    this.paginator = this.dm.createPaginator(this.rowsPerPage);
  }

}
