import {
  animate,
  state,
  style,
  trigger,
  transition,
} from '@angular/animations';

export const TRANSITION_TIME = 400;

export const TRANSITION_TIMING = `${TRANSITION_TIME}ms ease-in-out`;

export const navigationTrigger = trigger('navigationTrigger', [
  state(
    'active',
    style({
      opacity: 1,
      transform: 'translateX(0)',
      position: 'relative',
    })
  ),
  state(
    'previous',
    style({
      opacity: 0,
      transform: 'translateX(-100%)',
      position: 'absolute',
    })
  ),
  state(
    'next',
    style({
      opacity: 0,
      transform: 'translateX(100%)',
      position: 'absolute',
    })
  ),
  transition('active <=> previous', animate(TRANSITION_TIMING)),
  transition('active <=> next', animate(TRANSITION_TIMING)),
]);

export const breadcrumbTrigger = trigger('breadcrumbTrigger', [
  state('active, previous', style({ opacity: 1 })),
  state('next', style({ opacity: 0 })),
  transition('next => active', animate(TRANSITION_TIMING)),
]);
