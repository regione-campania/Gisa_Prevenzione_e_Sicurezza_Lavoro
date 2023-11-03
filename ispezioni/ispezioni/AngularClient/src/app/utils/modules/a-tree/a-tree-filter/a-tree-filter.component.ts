import { Component, Input, OnInit } from '@angular/core';
import { Tree, TreeFilter, TreeNode } from '..';
import { ATreeNodeComponent } from '../a-tree-node/a-tree-node.component';
import { ATreeComponent } from '../a-tree.component';

@Component({
  selector: 'a-tree-filter',
  templateUrl: './a-tree-filter.component.html',
  styleUrls: ['./a-tree-filter.component.scss'],
})
export class ATreeFilterComponent implements TreeFilter, OnInit {
  @Input() tree?: ATreeComponent;
  @Input() placeholder?: string;

  filterMode: 'contains' | 'not-contains' | 'starts-with' | 'ends-with' = 'contains';
  pattern: string = '';
  isActive: boolean = false;
  keptItems: TreeNode[] = [];
  discardedItems: TreeNode[] = [];

  constructor() {}

  ngOnInit(): void {
  }

  apply(): void {
    if (!this.tree) throw new Error('Provide a Tree for this filter.');
    this.reset();
    let predicate: Function;
    switch (this.filterMode) {
      case 'contains':
        predicate = (x: string, y: string) => x.includes(y);
        break;
      case 'not-contains':
        predicate = (x: string, y: string) => !x.includes(y);
        break;
      case 'starts-with':
        predicate = (x: string, y: string) => x.startsWith(y);
        break;
      case 'ends-with':
        predicate = (x: string, y: string) => x.endsWith(y);
        break;
    }
    (function testPredicate(
      root: ATreeNodeComponent,
      thisArg: ATreeFilterComponent
    ) {
      root.expand();
      if (predicate(root.name?.toLowerCase(), thisArg.pattern.toLowerCase())) {
        root.show();
        thisArg.keptItems.push(root);
        return true;
      }
      let childMatch = false;
      root.childComponents?.forEach((child) => {
        if (testPredicate(child, thisArg) && !childMatch) childMatch = true;
      });
      if(childMatch) {
        root.show();
        thisArg.keptItems.push(root);
      }
      else {
        root.hide();
        thisArg.discardedItems.push(root);
      }
      return childMatch;
    })(this.tree.rootComponent!, this);
    this.isActive = this.discardedItems.length > 0;
  }

  reset(includePattern = false): void {
    (this.discardedItems as ATreeNodeComponent[]).forEach((node) => node.show());
    this.keptItems = [];
    this.discardedItems = [];
    if(includePattern) this.pattern = '';
    this.isActive = false;
  }
}
