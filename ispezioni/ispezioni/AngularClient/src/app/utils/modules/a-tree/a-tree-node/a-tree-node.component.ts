import {
  AfterViewInit,
  Component,
  ElementRef,
  EventEmitter,
  HostListener,
  Input,
  OnInit,
  Output,
  QueryList,
  ViewChildren,
} from '@angular/core';
import { TreeNode } from '..';

@Component({
  selector: 'a-tree-node',
  templateUrl: './a-tree-node.component.html',
  styleUrls: ['./a-tree-node.component.scss'],
})
export class ATreeNodeComponent implements TreeNode, OnInit {
  @Input() id?: string | number;
  @Input() name?: string;
  @Input() level?: number;
  @Input() data?: any;
  @Input() parent?: TreeNode;
  @Input() parentComponent?: ATreeNodeComponent;
  @Input() children?: TreeNode[];
  @Input() selectable? = false;
  private _selected? = false;
  @Input() indeterminate = false;
  @Input() expanded = false;
  @Input() hidden = false;
  @Input() disabled = false;

  @Output('onChange') changeEvent = new EventEmitter<void>();
  @Output('onClick') clickEvent = new EventEmitter<ATreeNodeComponent>();

  @ViewChildren(ATreeNodeComponent)
  childComponents!: QueryList<ATreeNodeComponent>;

  htmlElement: HTMLElement;
  readonly animationDuration = 333;

  constructor(private elementRef: ElementRef) {
    this.htmlElement = this.elementRef.nativeElement;
  }

  ngOnInit(): void {}

  expand() {
    this.expanded = true;
  }

  collapse() {
    this.expanded = false;
  }

  toggle() {
    this.expanded = !this.expanded;
  }

  hide() {
    this.hidden = true;
  }

  show() {
    this.hidden = false;
  }

  enable() {
    this.disabled = false;
  }

  disable() {
    this.disabled = true;
  }

  hasChildren() {
    return (this.children && this.children.length > 0) || false;
  }

  hasChildComponents() {
    return this.childComponents && this.childComponents.length > 0;
  }

  isLeafNode() {
    return !this.hasChildren() || !this.hasChildComponents();
  }

  /**
   * Change this component 'selected' status.
   *
   * @param value The new status; assigned to this.selected property.
   * @param propagate True if the new status has to be propagated to descendants
   * @param notify True if parent has to be notificated
   */
  changeStatus(
    value: boolean,
    propagate: boolean = true,
    notify: boolean = true
  ) {
    this.selected = value;
    if (propagate && this.childComponents)
      for (const child of this.childComponents)
        child.changeStatus(this.selected, true, false);
    if (notify) this.changeEvent.emit();
  }

  /**
   * Triggered when a child component changes its status.
   */
  checkStatus() {
    if (this.hasChildComponents()) {
      this.indeterminate = false;
      let hasSelectedChild = false;
      let hasUnselectedChild = false;
      for (let child of this.childComponents) {
        if (child.selected) hasSelectedChild = true;
        else hasUnselectedChild = true;
        if (child.indeterminate || (hasSelectedChild && hasUnselectedChild)) {
          this.selected = false;
          this.indeterminate = true;
          this.changeEvent.emit();
          return;
        }
      }
      //!hasUnselectedChild === has all child selected
      let newStatus = !hasUnselectedChild;
      if (newStatus !== this.selected)
        this.changeStatus(newStatus, false, true);
    }
  }

  /**
   * Removes this node from the DOM. (Same as Element.remove())
   */
  remove() {
    this.htmlElement.remove();
  }

  playAnimation() {
    let pulse = this.htmlElement.querySelector('.pulse');
    if(pulse) {
      pulse.animate([
        { transform: 'scale(0)', background: 'transparent' },
        { transform: 'scale(1.15)', background: 'rgb(225 225 225 / 30%)' },
      ], {
        duration: this.animationDuration,
        easing: 'cubic-bezier(0.16, 1, 0.3, 1)',
      })
    }
  }

  //accessors
  @Input()
  public get selected(): boolean | undefined {
    return this._selected;
  }

  public set selected(value: boolean | undefined) {
    this._selected = value;
    this.indeterminate = false;
  }

}
