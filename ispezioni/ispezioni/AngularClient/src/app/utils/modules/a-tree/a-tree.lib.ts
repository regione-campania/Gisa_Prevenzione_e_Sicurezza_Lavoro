import { Tree, TreeNode } from '.';
import { ATreeNodeComponent } from './a-tree-node/a-tree-node.component';

export function getFlatTree(root: TreeNode): TreeNode[] {
  let tree = [root];
  if (root.children)
    for (let child of root.children) tree.push(...getFlatTree(child));
  return tree;
}

export function getFlatTreeComponent(
  root: ATreeNodeComponent
): ATreeNodeComponent[] {
  let tree = [root];
  if (root.childComponents)
    for (let child of root.childComponents)
      tree.push(...getFlatTreeComponent(child));
  return tree;
}

export interface GenericNode {
  id: number;
  id_node: number;
  id_node_parent: number;
  descrizione: string;
  descrizione_breve: string;
  selezionabile: boolean;
  selezionato: boolean;
}

export interface NodeMappingFn {
  (node: any): TreeNode;
}

export interface ExtendedNodeMappingFn {
  (node: TreeNode): TreeNode;
}

const defalutNodeMappingFn: NodeMappingFn = function (node: any) {
  return {
    id: node.id_node,
    name: node.descrizione_breve,
    data: node,
    selectable: node.selezionabile,
    selected: node.selezionato,
    disabled: false,
    parent: undefined,
    children: [],
  };
};

/**
 * Parses a given array to a Tree.
 * @param array a GenericNode array to parse.
 * @param extendedMappingFn (optional) a function that is called after the default mapping.
 * @returns a Tree.
 */
export function toTree<T extends GenericNode>(
  array: T[],
  extendedMappingFn?: ExtendedNodeMappingFn
): Tree {
  let rootElem = array.find((el) => !el.id_node_parent);
  if (!rootElem) throw new Error('Nessun nodo radice trovato');
  return { root: parseNode(rootElem, undefined, array, extendedMappingFn) };
}

//toTree helper
function parseNode<T extends GenericNode>(
  el: T,
  parentNode: TreeNode | undefined,
  array: T[],
  extendedMappingFn?: ExtendedNodeMappingFn
) {
  let node = defalutNodeMappingFn(el);
  node.parent = parentNode;
  if (extendedMappingFn) node = extendedMappingFn(node);
  array.forEach((elem) => {
    if (elem.id_node_parent === el.id_node) {
      node.children?.push(parseNode(elem, node, array, extendedMappingFn));
    }
  });
  return node;
}
