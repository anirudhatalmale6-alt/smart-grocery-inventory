"""
Smart Grocery Inventory - Mobile Application
Uses Kivy framework to display grocery data from REST web services.
Connects to the SmartGroceryInventory JAX-RS API endpoints.
"""

import kivy
kivy.require('2.0.0')

from kivy.app import App
from kivy.uix.boxlayout import BoxLayout
from kivy.uix.gridlayout import GridLayout
from kivy.uix.scrollview import ScrollView
from kivy.uix.label import Label
from kivy.uix.button import Button
from kivy.uix.textinput import TextInput
from kivy.uix.tabbedpanel import TabbedPanel, TabbedPanelItem
from kivy.uix.popup import Popup
from kivy.uix.spinner import Spinner
from kivy.clock import Clock
from kivy.core.window import Window
from kivy.graphics import Color, Rectangle, RoundedRectangle, Line
from kivy.metrics import dp
from kivy.properties import StringProperty

import urllib.request
import urllib.error
import json
import threading

# Set window size to simulate mobile device
Window.size = (400, 700)

# ============================================================
#  CONFIGURATION - Change this URL to match your GlassFish server
# ============================================================
BASE_URL = "http://localhost:8080/SmartGroceryInventory/api"


class SmartGroceryApp(App):
    """Main Kivy application for Smart Grocery Inventory Mobile."""

    status_text = StringProperty("Ready")

    def build(self):
        self.title = "Smart Grocery Mobile"
        Window.clearcolor = (0.94, 0.95, 0.96, 1)
        return MainScreen()


class MainScreen(BoxLayout):
    """Main screen with tabbed navigation."""

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'vertical'
        self.spacing = 0
        self.padding = 0

        # Header
        header = BoxLayout(size_hint_y=None, height=dp(70))
        with header.canvas.before:
            Color(0.176, 0.416, 0.310, 1)  # #2d6a4f
            self.header_rect = Rectangle(pos=header.pos, size=header.size)
        header.bind(pos=self._update_header, size=self._update_header)

        header_label = Label(
            text="[b]Smart Grocery[/b]\n[size=12]Mobile Inventory[/size]",
            markup=True,
            font_size=dp(20),
            color=(1, 1, 1, 1),
            halign='center'
        )
        header.add_widget(header_label)
        self.add_widget(header)

        # Tab Panel
        tab_panel = TabbedPanel(
            do_default_tab=False,
            tab_width=dp(120),
            tab_height=dp(40),
        )
        tab_panel.background_color = (0.94, 0.95, 0.96, 1)

        # Grocery Items Tab
        grocery_tab = TabbedPanelItem(text='Grocery Items')
        grocery_tab.add_widget(GroceryItemsTab())
        tab_panel.add_widget(grocery_tab)

        # Suppliers Tab
        supplier_tab = TabbedPanelItem(text='Suppliers')
        supplier_tab.add_widget(SuppliersTab())
        tab_panel.add_widget(supplier_tab)

        # Categories Tab
        category_tab = TabbedPanelItem(text='Categories')
        category_tab.add_widget(CategoriesTab())
        tab_panel.add_widget(category_tab)

        self.add_widget(tab_panel)

        # Footer / Status Bar
        footer = BoxLayout(size_hint_y=None, height=dp(30))
        with footer.canvas.before:
            Color(0.85, 0.85, 0.85, 1)
            self.footer_rect = Rectangle(pos=footer.pos, size=footer.size)
        footer.bind(pos=self._update_footer, size=self._update_footer)

        self.status_label = Label(
            text="Ready - Configure server URL and tap Load",
            font_size=dp(10),
            color=(0.5, 0.5, 0.5, 1)
        )
        footer.add_widget(self.status_label)
        self.add_widget(footer)

    def _update_header(self, instance, value):
        self.header_rect.pos = instance.pos
        self.header_rect.size = instance.size

    def _update_footer(self, instance, value):
        self.footer_rect.pos = instance.pos
        self.footer_rect.size = instance.size


class BaseTab(BoxLayout):
    """Base class for data tabs with common functionality."""

    def __init__(self, endpoint, **kwargs):
        super().__init__(**kwargs)
        self.orientation = 'vertical'
        self.padding = dp(10)
        self.spacing = dp(8)
        self.endpoint = endpoint

        # Server URL input
        url_box = BoxLayout(size_hint_y=None, height=dp(35), spacing=dp(5))
        url_label = Label(
            text="Server:",
            size_hint_x=0.15,
            font_size=dp(11),
            color=(0.3, 0.3, 0.3, 1)
        )
        self.url_input = TextInput(
            text=BASE_URL,
            multiline=False,
            font_size=dp(11),
            size_hint_x=0.85,
            background_color=(1, 1, 1, 1),
            foreground_color=(0.2, 0.2, 0.2, 1),
            padding=[dp(8), dp(8)]
        )
        url_box.add_widget(url_label)
        url_box.add_widget(self.url_input)
        self.add_widget(url_box)

        # Action buttons
        btn_box = BoxLayout(size_hint_y=None, height=dp(40), spacing=dp(8))
        load_btn = Button(
            text="Load All",
            background_color=(0.176, 0.416, 0.310, 1),
            color=(1, 1, 1, 1),
            font_size=dp(13),
            bold=True
        )
        load_btn.bind(on_press=self.load_data)

        count_btn = Button(
            text="Get Count",
            background_color=(0, 0.467, 0.714, 1),
            color=(1, 1, 1, 1),
            font_size=dp(13),
            bold=True
        )
        count_btn.bind(on_press=self.load_count)

        btn_box.add_widget(load_btn)
        btn_box.add_widget(count_btn)
        self.add_widget(btn_box)

        # Search by ID
        id_box = BoxLayout(size_hint_y=None, height=dp(35), spacing=dp(5))
        self.id_input = TextInput(
            hint_text="Enter ID...",
            multiline=False,
            input_filter='int',
            font_size=dp(12),
            size_hint_x=0.5,
            padding=[dp(8), dp(8)]
        )
        find_btn = Button(
            text="Find by ID",
            size_hint_x=0.5,
            background_color=(0.251, 0.569, 0.424, 1),
            color=(1, 1, 1, 1),
            font_size=dp(12),
            bold=True
        )
        find_btn.bind(on_press=self.load_by_id)
        id_box.add_widget(self.id_input)
        id_box.add_widget(find_btn)
        self.add_widget(id_box)

        # Status label
        self.status_label = Label(
            text="Tap 'Load All' to fetch data from the web service",
            size_hint_y=None,
            height=dp(25),
            font_size=dp(11),
            color=(0.4, 0.4, 0.4, 1)
        )
        self.add_widget(self.status_label)

        # Scrollable results area
        scroll = ScrollView()
        self.results_layout = GridLayout(
            cols=1,
            spacing=dp(8),
            size_hint_y=None,
            padding=[0, dp(5)]
        )
        self.results_layout.bind(minimum_height=self.results_layout.setter('height'))
        scroll.add_widget(self.results_layout)
        self.add_widget(scroll)

    def load_data(self, instance):
        url = self.url_input.text.strip().rstrip('/') + "/" + self.endpoint
        self.status_label.text = "Loading..."
        self.status_label.color = (0, 0.467, 0.714, 1)
        threading.Thread(target=self._fetch, args=(url, self._display_list), daemon=True).start()

    def load_count(self, instance):
        url = self.url_input.text.strip().rstrip('/') + "/" + self.endpoint + "/count"
        self.status_label.text = "Getting count..."
        threading.Thread(target=self._fetch, args=(url, self._display_count), daemon=True).start()

    def load_by_id(self, instance):
        item_id = self.id_input.text.strip()
        if not item_id:
            self.status_label.text = "Please enter an ID"
            self.status_label.color = (0.9, 0.2, 0.2, 1)
            return
        url = self.url_input.text.strip().rstrip('/') + "/" + self.endpoint + "/" + item_id
        self.status_label.text = "Searching..."
        threading.Thread(target=self._fetch, args=(url, self._display_single), daemon=True).start()

    def _fetch(self, url, callback):
        try:
            req = urllib.request.Request(url)
            req.add_header('User-Agent', 'SmartGroceryMobile/1.0')
            req.add_header('Accept', 'application/json')
            with urllib.request.urlopen(req, timeout=10) as response:
                data = response.read().decode('utf-8')
            Clock.schedule_once(lambda dt: callback(data), 0)
        except urllib.error.HTTPError as e:
            error_msg = f"HTTP Error {e.code}: {e.reason}"
            Clock.schedule_once(lambda dt: self._show_error(error_msg), 0)
        except urllib.error.URLError as e:
            error_msg = f"Connection Error: {e.reason}"
            Clock.schedule_once(lambda dt: self._show_error(error_msg), 0)
        except Exception as e:
            error_msg = f"Error: {str(e)}"
            Clock.schedule_once(lambda dt: self._show_error(error_msg), 0)

    def _show_error(self, message):
        self.status_label.text = message
        self.status_label.color = (0.9, 0.2, 0.2, 1)
        self.results_layout.clear_widgets()
        error_card = self._make_card(
            "[color=#e63946][b]Connection Error[/b][/color]\n\n" + message +
            "\n\n[size=11]Make sure:\n1. GlassFish server is running\n"
            "2. The URL above is correct\n"
            "3. SmartGroceryInventory is deployed[/size]",
            accent_color=(0.9, 0.2, 0.2, 1)
        )
        self.results_layout.add_widget(error_card)

    def _display_count(self, data):
        self.results_layout.clear_widgets()
        self.status_label.text = "Count retrieved"
        self.status_label.color = (0.176, 0.416, 0.310, 1)
        card = self._make_card(
            f"[b][size=16]Total Records: {data}[/size][/b]",
            accent_color=(0, 0.467, 0.714, 1)
        )
        self.results_layout.add_widget(card)

    def _display_list(self, data):
        raise NotImplementedError

    def _display_single(self, data):
        raise NotImplementedError

    def _make_card(self, text, accent_color=(0.176, 0.416, 0.310, 1)):
        card = BoxLayout(
            orientation='vertical',
            size_hint_y=None,
            padding=[dp(15), dp(12)],
            spacing=dp(4)
        )
        with card.canvas.before:
            Color(*accent_color)
            self.card_accent = Rectangle(pos=card.pos, size=(dp(4), card.height))
            Color(1, 1, 1, 1)
            self.card_bg = Rectangle(pos=(card.x + dp(4), card.y),
                                     size=(card.width - dp(4), card.height))

        def update_card_bg(instance, value):
            instance.canvas.before.clear()
            with instance.canvas.before:
                Color(*accent_color)
                Rectangle(pos=instance.pos, size=(dp(4), instance.height))
                Color(1, 1, 1, 1)
                Rectangle(pos=(instance.x + dp(4), instance.y),
                         size=(instance.width - dp(4), instance.height))

        card.bind(pos=update_card_bg, size=update_card_bg)

        label = Label(
            text=text,
            markup=True,
            font_size=dp(12),
            color=(0.2, 0.2, 0.2, 1),
            halign='left',
            valign='top',
            size_hint_y=None,
            text_size=(Window.width - dp(60), None)
        )
        label.bind(texture_size=label.setter('size'))
        card.add_widget(label)
        card.bind(minimum_height=card.setter('height'))
        return card


class GroceryItemsTab(BaseTab):
    """Tab for displaying grocery items from the web service."""

    def __init__(self, **kwargs):
        super().__init__(endpoint="groceryitems", **kwargs)

    def _display_list(self, data):
        self.results_layout.clear_widgets()
        try:
            items = json.loads(data)
            self.status_label.text = f"Loaded {len(items)} grocery item(s)"
            self.status_label.color = (0.176, 0.416, 0.310, 1)

            if not items:
                card = self._make_card("[i]No grocery items found in the database.[/i]")
                self.results_layout.add_widget(card)
                return

            for item in items:
                text = (
                    f"[b][size=14]{item.get('itemName', 'N/A')}[/size][/b]\n"
                    f"[color=#2d6a4f]Brand:[/color] {item.get('brand', 'N/A')}  |  "
                    f"[color=#2d6a4f]Category:[/color] {item.get('category', 'N/A')}\n"
                    f"[color=#2d6a4f]Qty:[/color] {item.get('quantity', 0)}  |  "
                    f"[color=#2d6a4f]Price:[/color] ${item.get('price', 0):.2f}\n"
                    f"[color=#2d6a4f]Expiry:[/color] {item.get('expiryDate', 'N/A')}  |  "
                    f"[color=#2d6a4f]Supplier:[/color] {item.get('supplier', 'N/A')}"
                )
                if item.get('description'):
                    text += f"\n[color=#666666][size=11]{item['description']}[/size][/color]"
                card = self._make_card(text, accent_color=(0.251, 0.569, 0.424, 1))
                self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")

    def _display_single(self, data):
        self.results_layout.clear_widgets()
        try:
            item = json.loads(data)
            if 'error' in item:
                self.status_label.text = item['error']
                self.status_label.color = (0.9, 0.2, 0.2, 1)
                card = self._make_card(f"[color=#e63946]{item['error']}[/color]",
                                      accent_color=(0.9, 0.2, 0.2, 1))
                self.results_layout.add_widget(card)
                return

            self.status_label.text = f"Found: {item.get('itemName', 'N/A')}"
            self.status_label.color = (0.176, 0.416, 0.310, 1)
            text = (
                f"[b][size=16]{item.get('itemName', 'N/A')}[/size][/b]\n\n"
                f"[b]ID:[/b] {item.get('itemId', 'N/A')}\n"
                f"[b]Brand:[/b] {item.get('brand', 'N/A')}\n"
                f"[b]Category:[/b] {item.get('category', 'N/A')}\n"
                f"[b]Quantity:[/b] {item.get('quantity', 0)}\n"
                f"[b]Price:[/b] ${item.get('price', 0):.2f}\n"
                f"[b]Expiry Date:[/b] {item.get('expiryDate', 'N/A')}\n"
                f"[b]Supplier:[/b] {item.get('supplier', 'N/A')}\n"
                f"[b]Description:[/b] {item.get('description', 'N/A')}"
            )
            card = self._make_card(text, accent_color=(0.176, 0.416, 0.310, 1))
            self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")


class SuppliersTab(BaseTab):
    """Tab for displaying suppliers from the web service."""

    def __init__(self, **kwargs):
        super().__init__(endpoint="suppliers", **kwargs)

    def _display_list(self, data):
        self.results_layout.clear_widgets()
        try:
            suppliers = json.loads(data)
            self.status_label.text = f"Loaded {len(suppliers)} supplier(s)"
            self.status_label.color = (0.176, 0.416, 0.310, 1)

            if not suppliers:
                card = self._make_card("[i]No suppliers found in the database.[/i]")
                self.results_layout.add_widget(card)
                return

            for s in suppliers:
                text = (
                    f"[b][size=14]{s.get('supplierName', 'N/A')}[/size][/b]\n"
                    f"[color=#0077b6]Contact:[/color] {s.get('contactPerson', 'N/A')}\n"
                    f"[color=#0077b6]Email:[/color] {s.get('email', 'N/A')}\n"
                    f"[color=#0077b6]Phone:[/color] {s.get('phone', 'N/A')}\n"
                    f"[color=#0077b6]Products:[/color] {s.get('productsSupplied', 'N/A')}\n"
                    f"[color=#0077b6]Schedule:[/color] {s.get('deliverySchedule', 'N/A')}"
                )
                card = self._make_card(text, accent_color=(0, 0.467, 0.714, 1))
                self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")

    def _display_single(self, data):
        self.results_layout.clear_widgets()
        try:
            s = json.loads(data)
            if 'error' in s:
                self.status_label.text = s['error']
                self.status_label.color = (0.9, 0.2, 0.2, 1)
                card = self._make_card(f"[color=#e63946]{s['error']}[/color]",
                                      accent_color=(0.9, 0.2, 0.2, 1))
                self.results_layout.add_widget(card)
                return

            self.status_label.text = f"Found: {s.get('supplierName', 'N/A')}"
            self.status_label.color = (0.176, 0.416, 0.310, 1)
            text = (
                f"[b][size=16]{s.get('supplierName', 'N/A')}[/size][/b]\n\n"
                f"[b]ID:[/b] {s.get('supplierId', 'N/A')}\n"
                f"[b]Contact Person:[/b] {s.get('contactPerson', 'N/A')}\n"
                f"[b]Email:[/b] {s.get('email', 'N/A')}\n"
                f"[b]Phone:[/b] {s.get('phone', 'N/A')}\n"
                f"[b]Address:[/b] {s.get('address', 'N/A')}\n"
                f"[b]Products Supplied:[/b] {s.get('productsSupplied', 'N/A')}\n"
                f"[b]Delivery Schedule:[/b] {s.get('deliverySchedule', 'N/A')}\n"
                f"[b]Notes:[/b] {s.get('notes', 'N/A')}"
            )
            card = self._make_card(text, accent_color=(0, 0.467, 0.714, 1))
            self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")


class CategoriesTab(BaseTab):
    """Tab for displaying categories from the web service."""

    def __init__(self, **kwargs):
        super().__init__(endpoint="categories", **kwargs)

    def _display_list(self, data):
        self.results_layout.clear_widgets()
        try:
            categories = json.loads(data)
            self.status_label.text = f"Loaded {len(categories)} category(ies)"
            self.status_label.color = (0.176, 0.416, 0.310, 1)

            if not categories:
                card = self._make_card("[i]No categories found in the database.[/i]")
                self.results_layout.add_widget(card)
                return

            for c in categories:
                text = (
                    f"[b][size=14]{c.get('categoryName', 'N/A')}[/size][/b]\n"
                    f"[color=#e76f51]Aisle:[/color] {c.get('aisleNumber', 'N/A')}  |  "
                    f"[color=#e76f51]Storage:[/color] {c.get('storageType', 'N/A')}\n"
                    f"[color=#e76f51]Shelf Life:[/color] {c.get('shelfLife', 'N/A')}  |  "
                    f"[color=#e76f51]Perishable:[/color] {c.get('isPerishable', 'N/A')}\n"
                    f"[color=#e76f51]Min Stock:[/color] {c.get('minStockLevel', 0)}"
                )
                if c.get('description'):
                    text += f"\n[color=#666666][size=11]{c['description']}[/size][/color]"
                card = self._make_card(text, accent_color=(0.906, 0.435, 0.318, 1))
                self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")

    def _display_single(self, data):
        self.results_layout.clear_widgets()
        try:
            c = json.loads(data)
            if 'error' in c:
                self.status_label.text = c['error']
                self.status_label.color = (0.9, 0.2, 0.2, 1)
                card = self._make_card(f"[color=#e63946]{c['error']}[/color]",
                                      accent_color=(0.9, 0.2, 0.2, 1))
                self.results_layout.add_widget(card)
                return

            self.status_label.text = f"Found: {c.get('categoryName', 'N/A')}"
            self.status_label.color = (0.176, 0.416, 0.310, 1)
            text = (
                f"[b][size=16]{c.get('categoryName', 'N/A')}[/size][/b]\n\n"
                f"[b]ID:[/b] {c.get('categoryId', 'N/A')}\n"
                f"[b]Aisle Number:[/b] {c.get('aisleNumber', 'N/A')}\n"
                f"[b]Storage Type:[/b] {c.get('storageType', 'N/A')}\n"
                f"[b]Shelf Life:[/b] {c.get('shelfLife', 'N/A')}\n"
                f"[b]Perishable:[/b] {c.get('isPerishable', 'N/A')}\n"
                f"[b]Min Stock Level:[/b] {c.get('minStockLevel', 0)}\n"
                f"[b]Description:[/b] {c.get('description', 'N/A')}"
            )
            card = self._make_card(text, accent_color=(0.906, 0.435, 0.318, 1))
            self.results_layout.add_widget(card)
        except json.JSONDecodeError:
            self._show_error("Invalid JSON response from server")


if __name__ == '__main__':
    SmartGroceryApp().run()
