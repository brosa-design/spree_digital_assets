Deface::Override.new(virtual_path: 'spree/layouts/admin',
  name: 'add_asset_list_to_side_menu',
  insert_bottom: "[data-hook='admin_tabs'], #admin_tabs[data-hook]",
  partial: 'spree/admin/shared/folder_list',
  original: '8d05a6b687057aa2a8c08b3feb480d58a14fe4aa')
