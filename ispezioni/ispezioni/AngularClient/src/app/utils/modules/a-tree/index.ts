export * from "./a-tree.lib";

export interface TreeNode {
  id?: string | number;
  name?: string;
  level?: number;
  data?: any;
  selectable?: boolean;
  selected?: boolean;
  expanded?: boolean;
  disabled?: boolean;
  parent?: TreeNode;
  children?: TreeNode[];
}

export interface Tree {
  root?: TreeNode;
}

export interface TreeFilter {
  tree?: Tree;
  pattern: string;
  filterMode: 'contains' | 'not-contains' | 'starts-with' | 'ends-with';
  isActive: boolean;
  apply: () => void;
  reset: () => void;
  keptItems: TreeNode[];
  discardedItems: TreeNode[];
}
