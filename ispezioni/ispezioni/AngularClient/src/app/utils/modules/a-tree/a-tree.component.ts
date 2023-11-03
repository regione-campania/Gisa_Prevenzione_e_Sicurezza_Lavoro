import { AfterViewInit, Component, EventEmitter, Input, OnInit, Output, ViewChild, } from '@angular/core';
import { Tree, TreeNode } from '.';
import { ATreeNodeComponent } from './a-tree-node/a-tree-node.component';
import { getFlatTreeComponent } from './a-tree.lib';

@Component({
  selector: 'a-tree',
  templateUrl: './a-tree.component.html',
  styleUrls: ['./a-tree.component.scss']
})
export class ATreeComponent implements Tree, OnInit {
  @Output('onChange') changeEvent = new EventEmitter<ATreeComponent>();
  @Output('onClick') clickEvent = new EventEmitter<ATreeNodeComponent>();
  @Output('onLoad') loadEvent = new EventEmitter<ATreeComponent>(); //emits when three is fully loaded
  @ViewChild(ATreeNodeComponent) rootComponent?: ATreeNodeComponent;

  private _root?: TreeNode | undefined;

  constructor() {}

  ngOnInit(): void {
  }

  checkStatus() {
    this.nodes?.forEach(n => n.checkStatus());
  }

  //computed props
  get nodes() {
    if(!this.rootComponent) return undefined;
    return getFlatTreeComponent(this.rootComponent);
  }

  get leafNodes() {
    if(!this.rootComponent) return undefined;
    return getFlatTreeComponent(this.rootComponent).filter(node => node.isLeafNode());
  }

  //accessors
  @Input('root')
  public get root(): TreeNode | undefined {
    return this._root;
  }

  public set root(value: TreeNode | undefined) {
    this._root = value;
    setTimeout(() => {
      this.checkStatus();
      this.loadEvent.emit();
    });
  }
}
