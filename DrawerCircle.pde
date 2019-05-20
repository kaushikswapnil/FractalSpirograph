class DrawerCircle
{
   PVector m_Position;
   float m_Radius;
  
   float m_Speed, m_Angle;
   
   int m_Level;
   
   DrawerCircle m_Parent, m_Child;   
   
   DrawerCircle(float posX, float posY, float radius, int level, float angle)
   {
      this(posX, posY, radius, level, angle, null, null); 
   }
   
   DrawerCircle(float posX, float posY, float radius, int level, float angle, DrawerCircle parent, DrawerCircle child)
   {
     m_Position = new PVector(posX, posY);
     m_Radius = radius;
     
     m_Level = level;
     m_Speed = radians(pow(speedConstant, level));
     m_Angle = angle;
     
     m_Parent = parent;
     m_Child = child;
   }   
   
   DrawerCircle(float posX, float posY, float radius, DrawerCircle parent)
   {
     this(posX, posY, radius, 0, 0, parent, null); 
   }
   
   void CreateNewChild()
   {
      float radius = m_Radius * radiusMultiplier;
      
      float posX = 0;
      switch (childCreationStrategy)
      {
        default:
        case 0 :
        posX = m_Position.x + m_Radius + radius;
        break;
        
        case 1:
        posX = m_Position.x + m_Radius - radius;
        break;
        
        case 2:
        if (m_Level % 2 == 0)
          posX = m_Position.x + m_Radius - radius;
        else
          posX = m_Position.x + m_Radius + radius;
        break;
      }
      float posY = m_Position.y;
      
      int level = m_Level+1;
      float angle = m_Angle;
      
      m_Child = new DrawerCircle(posX, posY, radius, level, angle, this, null);
   }
   
   void Update()
   {
     if (m_Parent != null)
     {
       float radiusSum = FetchResultantRadiusForChildCreationStrategy();
     
       m_Position.x = m_Parent.m_Position.x + (radiusSum* cos(m_Angle));
       m_Position.y = m_Parent.m_Position.y + (radiusSum* sin(m_Angle));
     
       m_Angle += m_Speed;
     }
     
     if (m_Child != null)
     {
        m_Child.Update(); 
     }
   }
   
   void Display()
   {
      stroke(255);
      strokeWeight(2);
      noFill();
      float diameter = m_Radius*2;
      ellipse(m_Position.x, m_Position.y, diameter, diameter); 
      
      if (m_Child != null)
      {
         m_Child.Display(); 
      }
   }
   
   PVector GetLeafCenter()
   {
      if (m_Child != null)
      {
         return m_Child.GetLeafCenter(); 
      }
      else
      {
        return new PVector(m_Position.x, m_Position.y);
      }
   }
   
   //Fetches the appropriate radius sum for parent and this entity
   //based on the child creation strategy
   //assumes parent is already present. Do not call this method if parent does not exist
   float FetchResultantRadiusForChildCreationStrategy()
   {
     float radiusSum = 0;
     
     switch (childCreationStrategy)
      {
        default:
        case 0 :
        radiusSum = m_Parent.m_Radius + m_Radius;
        break;
        
        case 1:
        radiusSum = m_Parent.m_Radius - m_Radius;
        break;
        
        case 2:
        if (m_Level % 2 == 0)
          radiusSum = m_Parent.m_Radius + m_Radius;
        else
          radiusSum = m_Parent.m_Radius - m_Radius;
        break;
      }
      
      return radiusSum;
   }
}
