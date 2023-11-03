import { animate, state, style, transition, trigger } from '@angular/animations';
import { AfterContentInit, AfterViewInit, Component, ContentChildren, OnInit, QueryList, EventEmitter, Output, OnChanges } from '@angular/core';
import { DataStorage, stretchToWindow } from '../../lib';
import { ATabDirective } from './a-tab/a-tab.directive';

const HIDE_DURATION = 100; //in milliseconds
const SHOW_DURATION = 200; //in milliseconds
const ANIMATION_TIMING_FUNCTION = 'cubic-bezier(0.16, 1, 0.3, 1)';

@Component({
  selector: 'a-tabber',
  templateUrl: './a-tabber.component.html',
  styleUrls: ['./a-tabber.component.scss'],
  animations: [
    trigger('tabSwitchTrigger', [
      state('false', style({
        opacity: 1,
      })),
      state('true', style({
        top: '-6px',
        opacity: 0,
      })),
      transition('false => true', [
        animate(`${HIDE_DURATION}ms ${ANIMATION_TIMING_FUNCTION}`)
      ]),
      transition('true => false', [
        animate(`${SHOW_DURATION}ms ${ANIMATION_TIMING_FUNCTION}`)
      ])
    ])
  ]
})
export class ATabberComponent implements OnInit, AfterContentInit, AfterViewInit {
  @ContentChildren(ATabDirective) tabs!: QueryList<ATabDirective>;
  @Output('onTabSwitch') tabSwitchEvent = new EventEmitter<ATabberComponent>();
  private _activeTab?: ATabDirective;
  private _animationPlaying = false;
  private _storage = new DataStorage();

  constructor() {}

  ngOnInit(): void {
  }

  ngAfterContentInit(): void {
    setTimeout(() => this._activeTab = this.tabs.first);
  }

  ngAfterViewInit(): void {
    /* let viewContainer = document.querySelector('.view-container') as HTMLElement;
    if(!viewContainer) throw new Error('Cannot find view-container.');
    setTimeout(() => stretchToWindow(viewContainer, '20px', {marginBottom: '20px', overflowX: 'hidden'}), 0);
    window.addEventListener('resize', () => stretchToWindow(viewContainer, '20px')); */
  }

  switchTab(indexOrName: number | string) {
    let next: ATabDirective | undefined;
    if (typeof indexOrName === 'number')
      next = this.tabs.get(indexOrName);
    else
      next = this.tabs.find(tab => tab.name.toLowerCase() === indexOrName.toLowerCase());
    this._animationPlaying = true;
    setTimeout(() => this._activeTab = next, HIDE_DURATION);
    setTimeout(() => this._animationPlaying = false, SHOW_DURATION);
    this.tabSwitchEvent.emit(this);
  }

  //accessors
  public get activeTab(): ATabDirective | undefined {
    return this._activeTab;
  }

  public get animationPlaying() {
    return this._animationPlaying;
  }

  public get storage() {
    return this._storage;
  }

}
