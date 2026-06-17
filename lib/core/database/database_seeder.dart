import 'package:sqflite/sqflite.dart';

class DatabaseSeeder {
  static Future<void> seed(Database db) async {
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM categories'));
    if (count != null && count > 0) {
      await db.execute('DELETE FROM checklist_items');
      await db.execute('DELETE FROM lessons');
      await db.execute('DELETE FROM courses');
      await db.execute('DELETE FROM categories');
    }

    // Insert Categories
    final categories = [
      {'id': 1, 'name': 'E-Commerce', 'emoji': '🛍️', 'color_hex': '#10B981', 'sort_order': 1},
      {'id': 2, 'name': 'Dropshipping', 'emoji': '📦', 'color_hex': '#F59E0B', 'sort_order': 2},
      {'id': 3, 'name': 'FBA Private Label', 'emoji': '🏷️', 'color_hex': '#3B82F6', 'sort_order': 3},
    ];

    for (var cat in categories) {
      await db.insert('categories', cat);
    }

    // Insert Courses
    final courses = [
      // E-Commerce (Cat 1)
      {
        'id': 1, 'category_id': 1, 'title': 'Branded E-Commerce Masterclass', 'subtitle': 'ZERO TO PROFIT',
        'description': 'Learn how to build a high-converting, inventory-backed e-commerce brand from scratch.',
        'emoji': '🛍️', 'badge_label': 'POPULAR', 'badge_type': 'high_impact',
        'expected_roi': 'High Margins', 'investment_level': 'Medium', 'time_required': '4 Weeks',
        'difficulty': 'beginner', 'total_steps': 5, 'sort_order': 1,
      },
      // Dropshipping (Cat 2)
      {
        'id': 2, 'category_id': 2, 'title': 'Dropshipping Fundamentals', 'subtitle': 'ZERO INVENTORY',
        'description': 'Master the art of selling without holding inventory. Find winning products and scale fast.',
        'emoji': '📦', 'badge_label': 'LOW RISK', 'badge_type': 'beginner',
        'expected_roi': 'Volume Sales', 'investment_level': 'Low', 'time_required': '2 Weeks',
        'difficulty': 'beginner', 'total_steps': 4, 'sort_order': 1,
      },
      // Amazon FBA (Cat 3)
      {
        'id': 3, 'category_id': 3, 'title': 'FBA Private Label Blueprint', 'subtitle': 'BRAND BUILDING',
        'description': 'Source products, build your brand, and leverage Amazon\'s massive fulfillment network.',
        'emoji': '🏷️', 'badge_label': 'HIGH PROFIT', 'badge_type': 'digital_first',
        'expected_roi': 'Sustainable Income', 'investment_level': 'High', 'time_required': '8 Weeks',
        'difficulty': 'advanced', 'total_steps': 5, 'sort_order': 1,
      },
    ];

    for (var course in courses) {
      await db.insert('courses', course);
    }

    // Insert Lessons
    final lessons = [
      // --- E-COMMERCE (Course 1) ---
      {
        'id': 1, 'course_id': 1, 'step_number': 1, 'category_label': 'FOUNDATION',
        'title': 'Product Research & Sourcing', 'description': 'Find what to sell and where to get it.',
        'content': '''For a traditional e-commerce brand, your product is everything. You need to sell something that solves a problem, fulfills a passion, or significantly improves a customer's life.

Step 1: Market Research
Use Google Trends to see if a product interest is growing. Look at Amazon Best Sellers and TikTok hashtags (#tiktokmademebuyit) to see what is currently trending. Do not copy exact products; find a way to improve them.

Step 2: Sourcing the Product
You will need physical inventory. Go to Alibaba.com and search for manufacturers (not trading companies). Look for verified suppliers with "Trade Assurance". Order samples from at least 3 different factories. Check the quality, shipping time, and communication.

Step 3: Calculating Margins
Ensure you have at least a 3x to 4x markup. If it costs \$10 to manufacture and ship to you, you must be able to sell it for \$30 to \$40 to cover marketing and operations.''',
        'expert_insight': 'Don\'t compete on price alone. Find a product where you can improve the quality, design, or customer experience. People pay premium prices for premium branding.',
        'reading_minutes': 15, 'sort_order': 1,
      },
      {
        'id': 2, 'course_id': 1, 'step_number': 2, 'category_label': 'BRANDING',
        'title': 'Brand Identity', 'description': 'Create a brand that people trust.',
        'content': '''Your brand is the soul of your business. It is what separates you from cheap knockoffs on AliExpress.

Step 1: Naming & Domain
Choose a short, memorable name. Use a domain name generator like LeanDomainSearch. Secure the .com domain via Namecheap or GoDaddy.

Step 2: Visual Identity
Use Canva or hire a freelancer on Fiverr/Upwork to create a clean, modern logo. Pick 2-3 brand colors and stick to them consistently across your website, packaging, and social media.

Step 3: The "Why"
Write a compelling "About Us" page. Customers buy stories, not just products. Explain why you started this brand and what your mission is. ''',
        'expert_insight': 'A professional unboxing experience drastically increases repeat purchases and social media sharing. Consider custom tissue paper or thank-you cards inside the box.',
        'reading_minutes': 10, 'sort_order': 2,
      },
      {
        'id': 3, 'course_id': 1, 'step_number': 3, 'category_label': 'STORE SETUP',
        'title': 'Building Your Shopify Store', 'description': 'Set up your online storefront.',
        'content': '''Shopify is the gold standard for e-commerce. It is fast, secure, and has all the apps you need.

Step 1: Theme Selection
Start with a free theme like 'Dawn' or 'Sense'. Keep the design minimalist. A cluttered website kills conversion rates. White backgrounds, dark text, and clear buttons.

Step 2: Product Pages
Your product page is your sales pitch. Include at least 4-5 high-quality lifestyle images and a video showing the product in action. Write benefit-driven descriptions. Don't just list features; explain how it improves the customer's life.

Step 3: Trust Signals
Add a FAQ section, clear shipping/return policies, and a contact email. Use apps like 'Loox' or 'Judge.me' to import and display customer reviews.''',
        'expert_insight': 'Optimize for mobile! Over 70% of e-commerce traffic comes from smartphones. Ensure your "Add to Cart" button is always visible on a phone screen.',
        'youtube_id': 'uorQJ_ucDhg', 'reading_minutes': 20, 'sort_order': 3,
      },
      {
        'id': 4, 'course_id': 1, 'step_number': 4, 'category_label': 'LOGISTICS',
        'title': 'Inventory & Fulfillment', 'description': 'Manage your stock and shipping.',
        'content': '''Once orders start rolling in, you need a system to get the product to the customer fast.

Step 1: Storage
If you are just starting, storing inventory in your garage or spare room is fine. Keep it organized with clear bins and labels. 

Step 2: Shipping
Use services like Pirate Ship or ShipStation to get discounted USPS/UPS rates. Print shipping labels at home using a thermal printer (like a Rollo or Dymo). 

Step 3: Scaling to a 3PL
Once you hit 300+ orders a month, consider hiring a Third-Party Logistics (3PL) company. You ship your bulk inventory to them, and they automatically pack and ship orders as they come through Shopify.''',
        'expert_insight': 'Fast shipping is a major competitive advantage. Aim for 2-3 day delivery if possible. Always over-communicate tracking updates via email.',
        'reading_minutes': 12, 'sort_order': 4,
      },
      {
        'id': 5, 'course_id': 1, 'step_number': 5, 'category_label': 'MARKETING',
        'title': 'Launch & Traffic', 'description': 'Drive customers to your store.',
        'content': '''A beautiful store means nothing without traffic. You need eyeballs on your product.

Step 1: Organic Social Media
Create a TikTok and Instagram Reels account. Post 1-2 short, engaging videos daily showing the product naturally. Don't be too salesy.

Step 2: Paid Ads (Meta & TikTok)
Once you have some cash flow, start running Facebook/Instagram Ads and TikTok Ads. Test different video creatives. Keep videos short (15-20 seconds) with a strong hook in the first 3 seconds.

Step 3: Email Marketing
Install Klaviyo on your Shopify store. Set up an 'Abandoned Cart' email flow to recover lost sales, and a 'Welcome Series' giving new subscribers a 10% discount.''',
        'expert_insight': 'Your first ad campaign might not be profitable. That is normal. You are buying data to learn what creatives and audiences actually convert.',
        'reading_minutes': 18, 'sort_order': 5,
      },

      // --- DROPSHIPPING (Course 2) ---
      {
        'id': 6, 'course_id': 2, 'step_number': 1, 'category_label': 'RESEARCH',
        'title': 'Finding Winning Products', 'description': 'Identify trending products with high margins.',
        'content': '''In dropshipping, you don't hold inventory. You act as the middleman between the supplier and the customer. The product you choose dictates your success.

Criteria for a Winning Product:
• Solves a distinct problem (e.g., posture corrector, pet hair remover).
• Has a "Wow" factor (looks cool on video).
• Hard to find in local stores like Walmart or Target.
• Good profit margin (buy for \$10, sell for \$35).

How to Find Them:
Scroll TikTok using hashtags like #amazonfinds or #tiktokmademebuyit. Look for videos with high engagement (likes/comments) that were posted recently. Use spy tools like PiPiADS or Minea to see what ads other dropshippers are running profitably.''',
        'expert_insight': 'Do not sell clothing or electronics as a beginner. They have incredibly high return rates and customer service headaches.',
        'youtube_id': 'uorQJ_ucDhg', 'reading_minutes': 15, 'sort_order': 1,
      },
      {
        'id': 7, 'course_id': 2, 'step_number': 2, 'category_label': 'SUPPLIERS',
        'title': 'Vetting Suppliers', 'description': 'Find reliable partners who ship fast.',
        'content': '''The biggest risk in dropshipping is terrible shipping times from China. You must find suppliers who use fast shipping lines.

Option 1: AliExpress
Good for testing, but shipping can take 14-30 days. Only use suppliers with 95%+ positive feedback and who offer "AliExpress Standard Shipping".

Option 2: Private Agents & Platforms
Use platforms like Zendrop, AutoDS, or CJ Dropshipping. They integrate directly with Shopify and usually offer 7-12 day shipping to the US. 

Once you get 10-20 consistent orders a day, find a private sourcing agent via Facebook Groups. They will negotiate better prices and faster shipping directly with factories.''',
        'expert_insight': 'Always order a sample of the product to your own house first. Test the shipping speed and check if the product actually works before spending money on ads.',
        'reading_minutes': 12, 'sort_order': 2,
      },
      {
        'id': 8, 'course_id': 2, 'step_number': 3, 'category_label': 'STORE DESIGN',
        'title': 'Creating a High-Converting Store', 'description': 'Build trust instantly.',
        'content': '''Because dropshipping shipping times are often longer, your store must look incredibly trustworthy to compensate. Customers are skeptical.

Step 1: One-Product Store Setup
Instead of a general store, build a site dedicated entirely to your one winning product. Use the Shopify 'Dawn' theme.

Step 2: Copywriting & Media
Do not copy supplier images with Chinese text. Use clean GIFs showing the product working. Write copy that highlights the benefits, not just features.

Step 3: Trust Elements
Add a track order page. Include money-back guarantees. Ensure there are no spelling mistakes. Use professional color schemes (e.g., white, black, and one accent color).''',
        'expert_insight': 'Remove the "Powered by Shopify" text from your footer. Make sure your checkout process is completely seamless with express options like Apple Pay.',
        'reading_minutes': 15, 'sort_order': 3,
      },
      {
        'id': 9, 'course_id': 2, 'step_number': 4, 'category_label': 'ADS',
        'title': 'TikTok & Meta Ads', 'description': 'Test fast, kill the losers, scale the winners.',
        'content': '''Marketing is 90% of the dropshipping game. If you can make a good ad, you can sell anything.

TikTok Ads Strategy:
Your ad shouldn't look like an ad. It should look like an organic TikTok video. Use text-to-speech, trending sounds, and fast cuts. Demonstrate the product's value in the first 3 seconds.

Testing Phase:
Run low-budget CBO (Campaign Budget Optimization) campaigns. If an ad spends \$20-\$30 without generating an "Add to Cart", kill the ad. If it gets sales profitably, duplicate the ad group and increase the budget.

Iterate Quickly:
Dropshipping products burn out fast. Don't get emotionally attached. If a product fails after 3 days of testing, move on to the next one immediately.''',
        'expert_insight': 'User-Generated Content (UGC) is king. You can pay creators on platforms like Billo or Fiverr to record themselves using your product. These ads perform best.',
        'reading_minutes': 20, 'sort_order': 4,
      },

      // --- FBA PRIVATE LABEL (Course 3) ---
      {
        'id': 10, 'course_id': 3, 'step_number': 1, 'category_label': 'RESEARCH',
        'title': 'Amazon Product Research', 'description': 'Find high demand, low competition niches.',
        'content': '''Amazon FBA Private Label means you create your own brand of a product and Amazon stores and ships it for you. It requires upfront capital (\$2k-\$5k) but is highly scalable.

Step 1: Software Tools
You must use data. Subscribe to Jungle Scout or Helium 10. These tools show you exactly how many sales a product makes per month.

Step 2: The Perfect Criteria
You are looking for a product that generates \$5,000 to \$15,000 in monthly revenue, but the top sellers have less than 200 reviews. This means the market has demand, but the competition is weak enough for a new seller to enter.

Step 3: Differentiation
Read the negative 1-star and 2-star reviews of your competitors. What do customers hate? Use that feedback to instruct your manufacturer to improve the product.''',
        'expert_insight': 'Avoid products that are patented, seasonal, oversized, or electronic. Stick to simple, lightweight items that fit in a shoebox.',
        'youtube_id': 'sf7DukfFK8E', 'reading_minutes': 20, 'sort_order': 1,
      },
      {
        'id': 11, 'course_id': 3, 'step_number': 2, 'category_label': 'SOURCING',
        'title': 'Sourcing & Branding', 'description': 'Contact manufacturers and design packaging.',
        'content': '''You have found your product. Now you need to get it made.

Step 1: Alibaba Negotiation
Search Alibaba for the product. Contact 5-10 suppliers. Ask for their Minimum Order Quantity (MOQ) and pricing for 500 units. Ask them to implement the improvements you found during your research.

Step 2: Custom Packaging
Generic packaging screams "cheap". Hire a designer on Fiverr to create custom box packaging with your brand logo and UPC barcode. Send this design file to your Alibaba supplier to print.

Step 3: Quality Control
Never trust a factory blindly. Before paying the final balance, hire a third-party inspection company (like QIMA) in China to inspect the goods at the factory. ''',
        'expert_insight': 'Always pay suppliers via Alibaba Trade Assurance. This protects your money in case the goods are defective or not shipped on time.',
        'reading_minutes': 18, 'sort_order': 2,
      },
      {
        'id': 12, 'course_id': 3, 'step_number': 3, 'category_label': 'LISTING',
        'title': 'SEO & Listing Optimization', 'description': 'Rank higher on Amazon search.',
        'content': '''Your Amazon listing is your digital storefront. If it looks bad, people will click away.

Step 1: Photography
This is not the place to save money. Hire a professional Amazon photographer. You need:
• 1 Main Image (Pure white background, fills 85% of the frame).
• 3 Lifestyle Images (People using the product happily).
• 3 Infographics (Highlighting features and dimensions).

Step 2: Keyword SEO
Use Helium 10's Cerebro tool to find the exact keywords customers type to find your product. Put the most important keywords in your Title, Bullet Points, and Backend Search Terms.

Step 3: A+ Content
If you have a registered trademark, use A+ Content to add beautiful images and brand stories to the product description area.''',
        'expert_insight': 'Your main image is responsible for your Click-Through Rate (CTR). A brilliant main image can make or break your entire business.',
        'reading_minutes': 15, 'sort_order': 3,
      },
      {
        'id': 13, 'course_id': 3, 'step_number': 4, 'category_label': 'LOGISTICS',
        'title': 'Shipping to Amazon FBA', 'description': 'Navigate freight and customs.',
        'content': '''Getting goods from a factory in China to an Amazon warehouse in the US requires a Freight Forwarder.

Step 1: Creating a Shipping Plan
In your Amazon Seller Central account, create a shipping plan. Amazon will give you FNSKU barcode labels (which go on every single unit) and Box Labels (which go on the outer master cartons).

Step 2: Hiring a Freight Forwarder
Do not use the supplier's shipping method unless you have to. Hire a dedicated Freight Forwarder (e.g., Freightos or a private agent). They will pick up the goods from the factory, handle US Customs, and deliver directly to Amazon.

Step 3: Air vs Sea
Air DDP shipping takes 10-15 days but is expensive. Sea DDP shipping takes 30-45 days but is much cheaper. For your very first small test order, Air might be better. Transition to Sea as soon as possible to maximize profit margins.''',
        'expert_insight': 'Always ask your forwarder for "DDP" (Delivered Duty Paid) shipping. This means they handle all customs taxes, so you get no surprise bills.',
        'reading_minutes': 15, 'sort_order': 4,
      },
      {
        'id': 14, 'course_id': 3, 'step_number': 5, 'category_label': 'LAUNCH',
        'title': 'PPC Launch Strategy', 'description': 'Get initial sales and reviews.',
        'content': '''When your product arrives at Amazon, it will be on Page 50. Nobody will see it. You must spend money to force it to Page 1.

Step 1: Amazon Vine
Enroll in the Amazon Vine program. You give away up to 30 units for free to trusted Amazon reviewers in exchange for their honest review. You need at least 5-10 reviews before running heavy ads.

Step 2: Amazon PPC (Pay-Per-Click)
Run "Exact Match" sponsored ad campaigns for your top 5-10 highly relevant keywords. You will pay Amazon every time someone clicks your ad.

Step 3: Ranking
When a customer clicks your ad for a specific keyword and buys, Amazon's algorithm boosts your organic ranking for that keyword. In the first 2-4 weeks, expect to lose money or break even on ads. The goal is to rank organically on Page 1 so you can get free sales later.''',
        'expert_insight': 'Reviews are the ultimate currency on Amazon. Never buy fake reviews; Amazon will ban your account. Always play by the rules.',
        'reading_minutes': 20, 'sort_order': 5,
      },
    ];

    for (var lesson in lessons) {
      await db.insert('lessons', lesson);
    }

    // Insert Checklist Items
    final checklistItems = [
      // E-Commerce Course
      {'lesson_id': 1, 'label': 'ACTION ITEM', 'content': 'List 3 potential products and check trends', 'sort_order': 1},
      {'lesson_id': 1, 'label': 'ACTION ITEM', 'content': 'Order samples from 3 different Alibaba suppliers', 'sort_order': 2},
      {'lesson_id': 2, 'label': 'ACTION ITEM', 'content': 'Secure .com domain name', 'sort_order': 1},
      {'lesson_id': 2, 'label': 'ACTION ITEM', 'content': 'Design logo and establish 3 brand colors', 'sort_order': 2},
      {'lesson_id': 3, 'label': 'ACTION ITEM', 'content': 'Sign up for Shopify & install Dawn theme', 'sort_order': 1},
      {'lesson_id': 3, 'label': 'ACTION ITEM', 'content': 'Upload products with high-res photos', 'sort_order': 2},
      {'lesson_id': 4, 'label': 'ACTION ITEM', 'content': 'Purchase shipping labels and thermal printer', 'sort_order': 1},
      {'lesson_id': 5, 'label': 'ACTION ITEM', 'content': 'Launch first \$20/day Meta Ad campaign', 'sort_order': 1},

      // Dropshipping Course
      {'lesson_id': 6, 'label': 'ACTION ITEM', 'content': 'Find a product with a strong "wow" factor', 'sort_order': 1},
      {'lesson_id': 7, 'label': 'ACTION ITEM', 'content': 'Sign up for Zendrop, AutoDS or CJ Dropshipping', 'sort_order': 1},
      {'lesson_id': 7, 'label': 'ACTION ITEM', 'content': 'Order a sample to your house to test speed', 'sort_order': 2},
      {'lesson_id': 8, 'label': 'ACTION ITEM', 'content': 'Build 1-product Shopify store', 'sort_order': 1},
      {'lesson_id': 8, 'label': 'ACTION ITEM', 'content': 'Remove "Powered by Shopify" footer', 'sort_order': 2},
      {'lesson_id': 9, 'label': 'ACTION ITEM', 'content': 'Create 3 TikTok organic videos', 'sort_order': 1},

      // FBA Course
      {'lesson_id': 10, 'label': 'ACTION ITEM', 'content': 'Use Helium 10 to find product with <200 reviews', 'sort_order': 1},
      {'lesson_id': 11, 'label': 'ACTION ITEM', 'content': 'Negotiate MOQ with 5 Alibaba suppliers', 'sort_order': 1},
      {'lesson_id': 11, 'label': 'ACTION ITEM', 'content': 'Design custom packaging box', 'sort_order': 2},
      {'lesson_id': 12, 'label': 'ACTION ITEM', 'content': 'Hire professional photographer for main image', 'sort_order': 1},
      {'lesson_id': 13, 'label': 'ACTION ITEM', 'content': 'Create FBA Shipping Plan and print FNSKU labels', 'sort_order': 1},
      {'lesson_id': 14, 'label': 'ACTION ITEM', 'content': 'Enroll product in Amazon Vine program', 'sort_order': 1},
    ];

    for (var item in checklistItems) {
      await db.insert('checklist_items', item);
    }
  }
}
