import { Injectable } from '@angular/core';
import { createPopper, Instance } from '@popperjs/core';
import { ContextMenuOptionsConfig } from '.';

@Injectable({
  providedIn: 'root'
})
export class ContextMenuService {
  private _menu?: HTMLElement;
  private _anchor?: HTMLElement;
  private _popper?: Instance;

  constructor() {
    window.addEventListener('click', () => this.closeMenu());
    window.addEventListener('contextmenu', () => this.closeMenu());
    window.addEventListener('wheel', () => this.closeMenu());
    window.addEventListener('resize', () => this.closeMenu());
  }

  assignContextMenu(target: EventTarget, menuOptions: ContextMenuOptionsConfig) {
    target.addEventListener('contextmenu', (e) => {
      e.preventDefault();
      e.stopPropagation();
      this.closeMenu();
      this._anchor = this._createAnchor(e as PointerEvent);
      this._menu = this._createMenu(menuOptions);
      document.body.append(this._anchor);
      document.body.append(this._menu);
      this._popper = createPopper(this._anchor, this._menu, {placement: 'bottom-start'});
    });
  }

  closeMenu() {
    this._anchor?.remove();
    this._menu?.remove();
    this._popper?.destroy();
  }

  private _createMenu(menuOptions: ContextMenuOptionsConfig) {
    let ul = document.createElement('ul'); //menu list
    ul.className = 'context-menu';
    for(let opt of menuOptions) {
      if(!opt.context) opt.context = null;
      if(!opt.disabled) opt.disabled = false;
      let li = document.createElement('li');
      li.className = 'context-menu-option';
      if(opt.disabled) li.classList.add('disabled');
      li.innerText = opt.label;
      li.addEventListener('click', (e) => {
        e.preventDefault();
        if(!opt.disabled) opt.action(opt.context);
        this.closeMenu();
      });
      li.addEventListener('contextmenu', (e) => {
        e.preventDefault();
        e.stopPropagation();
        if(!opt.disabled) opt.action(opt.context);
        this.closeMenu();
      });
      ul.append(li);
    }
    return ul;
  }

  private _createAnchor(e: PointerEvent) {
    let anchor = document.createElement('div');
    Object.assign(anchor.style, {
      width: 0,
      height: 0,
      position: 'absolute',
      top: e.pageY + 'px',
      left: e.pageX + 'px',
    });
    return anchor;
  }
}
