export { ContextMenuService } from "./context-menu.service";

export interface ContextMenuOptionConfig {
  action: Function;
  label: string;
  context?: any;
  disabled?: boolean;
}

export type ContextMenuOptionsConfig = ContextMenuOptionConfig[];
